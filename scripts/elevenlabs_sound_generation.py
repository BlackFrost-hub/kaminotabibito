import json
import os
import ssl
import sys
import urllib.error
import urllib.parse
import urllib.request


API_URL = "https://api.elevenlabs.io/v1/sound-generation"
DEFAULT_OUTPUT_DIR = os.path.join("audio_temp")
DEFAULT_OUTPUT_FILE_NAME = "elevenlabs_sound_effect.mp3"
DEFAULT_PROMPT_INFLUENCE = 0.7
MAX_VARIANTS = 5


def ensure_parent_dir(path: str) -> None:
    parent = os.path.dirname(path)
    if parent:
        os.makedirs(parent, exist_ok=True)


def build_output_path(base_output_file: str, index: int, total: int) -> str:
    if total == 1:
        return base_output_file
    root, ext = os.path.splitext(base_output_file)
    return f"{root}_{index:02d}{ext}"


def resolve_output_file(output_arg: str | None) -> str:
    if not output_arg:
        return os.path.join(DEFAULT_OUTPUT_DIR, DEFAULT_OUTPUT_FILE_NAME)

    normalized_output = output_arg.rstrip("\\/")
    if not normalized_output:
        return os.path.join(DEFAULT_OUTPUT_DIR, DEFAULT_OUTPUT_FILE_NAME)

    # Treat values without an extension as directories so nested category paths work naturally.
    if not os.path.splitext(normalized_output)[1]:
        return os.path.join(normalized_output, DEFAULT_OUTPUT_FILE_NAME)

    return normalized_output


def parse_duration_arg(duration_arg: str | None) -> float | None:
    if not duration_arg:
        return 1.5

    normalized_duration = duration_arg.strip().lower()
    if normalized_duration in {"auto", "none", "default"}:
        return None

    duration_seconds = float(duration_arg)
    if duration_seconds < 0.5 or duration_seconds > 30:
        raise ValueError("duration_seconds must be between 0.5 and 30, or use 'auto'.")
    return duration_seconds


def parse_prompt_influence_arg(prompt_influence_arg: str | None) -> float:
    if not prompt_influence_arg:
        return DEFAULT_PROMPT_INFLUENCE

    prompt_influence = float(prompt_influence_arg)
    if prompt_influence < 0 or prompt_influence > 1:
        raise ValueError("prompt_influence must be between 0 and 1.")
    return prompt_influence


def parse_loop_arg(loop_arg: str | None) -> bool:
    if not loop_arg:
        return False

    normalized_loop = loop_arg.strip().lower()
    if normalized_loop in {"1", "true", "yes", "y", "on", "loop", "enable", "enabled"}:
        return True
    if normalized_loop in {"0", "false", "no", "n", "off", "noloop", "disable", "disabled"}:
        return False
    raise ValueError("loop must be true/false, on/off, 1/0, yes/no, or loop/noloop.")


def request_sound_effect(
    api_key: str,
    prompt: str,
    duration_seconds: float | None,
    output_format: str,
    prompt_influence: float,
    loop: bool,
) -> bytes:
    url = f"{API_URL}?{urllib.parse.urlencode({'output_format': output_format})}"
    payload = {
        "text": prompt,
        "loop": loop,
        "prompt_influence": prompt_influence,
    }
    if duration_seconds is not None:
        payload["duration_seconds"] = duration_seconds
    data = json.dumps(payload).encode("utf-8")

    request = urllib.request.Request(
        url,
        data=data,
        method="POST",
        headers={
            "xi-api-key": api_key,
            "Content-Type": "application/json",
        },
    )

    with urllib.request.urlopen(request, context=ssl.create_default_context()) as response:
        return response.read()


def print_generation_failure_help(error_body: str) -> None:
    print("Sound generation failed.")
    print("Please check the following first:")
    print("1. Run `python scripts\\elevenlabs_check_balance.py` to verify remaining credits.")
    print("2. Confirm the API key still has sound effect access.")
    print("3. Confirm ELEVENLABS_API_KEY in the current shell is the expected key.")
    if "quota" in error_body.lower() or "credit" in error_body.lower() or "balance" in error_body.lower():
        print("The error message suggests credits may be exhausted or insufficient.")


def print_usage() -> None:
    print("Usage:")
    print(
        'python scripts\\elevenlabs_sound_generation.py "PROMPT" DURATION_SECONDS_OR_AUTO '
        '"OUTPUT_PATH_OR_DIR" OUTPUT_FORMAT VARIANT_COUNT PROMPT_INFLUENCE LOOP'
    )
    print("Examples:")
    print(
        'python scripts\\elevenlabs_sound_generation.py "A short demonic roar" 1.5 '
        '"audio_temp\\demon\\roar" mp3_44100_128 3 0.7 false'
    )
    print(
        'python scripts\\elevenlabs_sound_generation.py "A looping cave fire ambience" auto '
        '"audio_temp\\env\\fire" mp3_44100_128 2 0.5 true'
    )


def main() -> int:
    api_key = os.getenv("ELEVENLABS_API_KEY")
    if not api_key:
        print("Missing ELEVENLABS_API_KEY environment variable.")
        print("PowerShell example:")
        print('$env:ELEVENLABS_API_KEY="your_api_key_here"')
        return 1

    prompt = (
        sys.argv[1]
        if len(sys.argv) > 1
        else "A short demonic roar, deep and brutal, isolated game sound effect"
    )
    output_file = resolve_output_file(sys.argv[3] if len(sys.argv) > 3 else None)
    output_format = sys.argv[4] if len(sys.argv) > 4 else "mp3_44100_128"
    variant_count = int(sys.argv[5]) if len(sys.argv) > 5 else 1
    try:
        duration_seconds = parse_duration_arg(sys.argv[2] if len(sys.argv) > 2 else None)
        prompt_influence = parse_prompt_influence_arg(sys.argv[6] if len(sys.argv) > 6 else None)
        loop = parse_loop_arg(sys.argv[7] if len(sys.argv) > 7 else None)
    except ValueError as error:
        print(error)
        print_usage()
        return 1
    if variant_count < 1:
        print("variant_count must be at least 1.")
        return 1
    if variant_count > MAX_VARIANTS:
        print(f"variant_count must be <= {MAX_VARIANTS}.")
        return 1

    print(f"duration_seconds: {'auto' if duration_seconds is None else duration_seconds}")
    print(f"prompt_influence: {prompt_influence}")
    print(f"loop: {loop}")

    try:
        for index in range(1, variant_count + 1):
            audio_bytes = request_sound_effect(
                api_key,
                prompt,
                duration_seconds,
                output_format,
                prompt_influence,
                loop,
            )
            current_output_file = build_output_path(output_file, index, variant_count)
            ensure_parent_dir(current_output_file)
            with open(current_output_file, "wb") as file:
                file.write(audio_bytes)
            print(f"Saved sound effect to: {os.path.abspath(current_output_file)}")
    except urllib.error.HTTPError as error:
        error_body = error.read().decode("utf-8", errors="replace")
        print(f"HTTP {error.code}")
        print(error_body)
        print_generation_failure_help(error_body)
        return 1
    except urllib.error.URLError as error:
        print(f"Request failed: {error}")
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
