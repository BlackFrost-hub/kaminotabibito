import json
import os
import ssl
import sys
import urllib.error
import urllib.parse
import urllib.request


DEFAULT_OUTPUT_DIR = os.path.join("audio_temp")
DEFAULT_OUTPUT_FILE_NAME = "elevenlabs_tts.mp3"
DEFAULT_VOICE_ID = "onwK4e9ZLuTAKqWW03F9"
DEFAULT_MODEL_ID = "eleven_multilingual_v2"
DEFAULT_STABILITY = 0.55
DEFAULT_SIMILARITY_BOOST = 0.8
DEFAULT_STYLE = 0.1
DEFAULT_SPEED = 0.95
DEFAULT_OUTPUT_FORMAT = "mp3_44100_128"


def ensure_parent_dir(path: str) -> None:
    parent = os.path.dirname(path)
    if parent:
        os.makedirs(parent, exist_ok=True)


def resolve_output_file(output_arg: str | None) -> str:
    if not output_arg:
        return os.path.join(DEFAULT_OUTPUT_DIR, DEFAULT_OUTPUT_FILE_NAME)

    normalized_output = output_arg.rstrip("\\/")
    if not normalized_output:
        return os.path.join(DEFAULT_OUTPUT_DIR, DEFAULT_OUTPUT_FILE_NAME)

    if not os.path.splitext(normalized_output)[1]:
        return os.path.join(normalized_output, DEFAULT_OUTPUT_FILE_NAME)

    return normalized_output


def parse_bool_arg(value: str | None, default: bool) -> bool:
    if value is None:
        return default

    normalized = value.strip().lower()
    if normalized in {"1", "true", "yes", "y", "on", "enable", "enabled"}:
        return True
    if normalized in {"0", "false", "no", "n", "off", "disable", "disabled"}:
        return False
    raise ValueError("use_speaker_boost must be true/false, on/off, 1/0, or yes/no.")


def parse_float_arg(value: str | None, default: float, name: str, minimum: float, maximum: float) -> float:
    if value is None:
        return default

    parsed = float(value)
    if parsed < minimum or parsed > maximum:
        raise ValueError(f"{name} must be between {minimum} and {maximum}.")
    return parsed


def request_tts(
    api_key: str,
    text: str,
    voice_id: str,
    model_id: str,
    stability: float,
    similarity_boost: float,
    style: float,
    speed: float,
    use_speaker_boost: bool,
    output_format: str,
    language_code: str | None,
    pronunciation_dictionary_id: str | None,
    pronunciation_dictionary_version_id: str | None,
) -> bytes:
    url = (
        f"https://api.elevenlabs.io/v1/text-to-speech/{voice_id}"
        f"?{urllib.parse.urlencode({'output_format': output_format})}"
    )
    payload = {
        "text": text,
        "model_id": model_id,
        "voice_settings": {
            "stability": stability,
            "similarity_boost": similarity_boost,
            "style": style,
            "speed": speed,
            "use_speaker_boost": use_speaker_boost,
        },
    }
    if language_code:
        payload["language_code"] = language_code
    if pronunciation_dictionary_id and pronunciation_dictionary_version_id:
        payload["pronunciation_dictionary_locators"] = [
            {
                "pronunciation_dictionary_id": pronunciation_dictionary_id,
                "version_id": pronunciation_dictionary_version_id,
            }
        ]
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


def print_usage() -> None:
    print("Usage:")
    print(
        'python scripts\\elevenlabs_tts_generation.py "TEXT" "OUTPUT_PATH_OR_DIR" '
        "VOICE_ID MODEL_ID STABILITY SIMILARITY_BOOST STYLE SPEED OUTPUT_FORMAT USE_SPEAKER_BOOST"
    )
    print("Example:")
    print(
        'python scripts\\elevenlabs_tts_generation.py "警告无效……那么，接受审判吧！律法之环，展开！" '
        '"audio_temp\\Boss\\Thranduil\\Voice\\thranduil_phase70_trial.mp3" '
        "onwK4e9ZLuTAKqWW03F9 eleven_multilingual_v2 0.55 0.8 0.1 0.95 mp3_44100_128 true zh"
    )


def main() -> int:
    api_key = os.getenv("ELEVENLABS_API_KEY")
    if not api_key:
        print("Missing ELEVENLABS_API_KEY environment variable.")
        print("PowerShell example:")
        print('$env:ELEVENLABS_API_KEY="your_api_key_here"')
        return 1

    text = sys.argv[1] if len(sys.argv) > 1 else "警告无效……那么，接受审判吧！律法之环，展开！"
    output_file = resolve_output_file(sys.argv[2] if len(sys.argv) > 2 else None)
    voice_id = sys.argv[3] if len(sys.argv) > 3 else DEFAULT_VOICE_ID
    model_id = sys.argv[4] if len(sys.argv) > 4 else DEFAULT_MODEL_ID

    try:
        stability = parse_float_arg(sys.argv[5] if len(sys.argv) > 5 else None, DEFAULT_STABILITY, "stability", 0, 1)
        similarity_boost = parse_float_arg(
            sys.argv[6] if len(sys.argv) > 6 else None,
            DEFAULT_SIMILARITY_BOOST,
            "similarity_boost",
            0,
            1,
        )
        style = parse_float_arg(sys.argv[7] if len(sys.argv) > 7 else None, DEFAULT_STYLE, "style", 0, 1)
        speed = parse_float_arg(sys.argv[8] if len(sys.argv) > 8 else None, DEFAULT_SPEED, "speed", 0.7, 1.2)
        output_format = sys.argv[9] if len(sys.argv) > 9 else DEFAULT_OUTPUT_FORMAT
        use_speaker_boost = parse_bool_arg(sys.argv[10] if len(sys.argv) > 10 else None, True)
        language_code = sys.argv[11] if len(sys.argv) > 11 and sys.argv[11].strip() else None
        pronunciation_dictionary_id = sys.argv[12] if len(sys.argv) > 12 and sys.argv[12].strip() else None
        pronunciation_dictionary_version_id = sys.argv[13] if len(sys.argv) > 13 and sys.argv[13].strip() else None
    except ValueError as error:
        print(error)
        print_usage()
        return 1

    print(f"voice_id: {voice_id}")
    print(f"model_id: {model_id}")
    print(f"stability: {stability}")
    print(f"similarity_boost: {similarity_boost}")
    print(f"style: {style}")
    print(f"speed: {speed}")
    print(f"use_speaker_boost: {use_speaker_boost}")
    print(f"output_format: {output_format}")
    print(f"language_code: {language_code or 'auto'}")
    if pronunciation_dictionary_id and pronunciation_dictionary_version_id:
        print(
            "pronunciation_dictionary: "
            f"{pronunciation_dictionary_id}@{pronunciation_dictionary_version_id}"
        )

    try:
        audio_bytes = request_tts(
            api_key,
            text,
            voice_id,
            model_id,
            stability,
            similarity_boost,
            style,
            speed,
            use_speaker_boost,
            output_format,
            language_code,
            pronunciation_dictionary_id,
            pronunciation_dictionary_version_id,
        )
        ensure_parent_dir(output_file)
        with open(output_file, "wb") as file:
            file.write(audio_bytes)
        print(f"Saved speech to: {os.path.abspath(output_file)}")
    except urllib.error.HTTPError as error:
        error_body = error.read().decode("utf-8", errors="replace")
        print(f"HTTP {error.code}")
        print(error_body)
        return 1
    except urllib.error.URLError as error:
        print(f"Request failed: {error}")
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
