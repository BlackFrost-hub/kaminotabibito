import datetime as dt
import json
import os
import ssl
import urllib.error
import urllib.request


API_URL = "https://api.elevenlabs.io/v1/user/subscription"


def format_reset_time(unix_seconds: int | None) -> str:
    if not unix_seconds:
        return "N/A"
    timestamp = dt.datetime.fromtimestamp(unix_seconds, tz=dt.timezone.utc)
    return timestamp.astimezone().isoformat()


def main() -> int:
    api_key = os.getenv("ELEVENLABS_API_KEY")
    if not api_key:
        print("Missing ELEVENLABS_API_KEY environment variable.")
        print("PowerShell example:")
        print('$env:ELEVENLABS_API_KEY="your_api_key_here"')
        return 1

    request = urllib.request.Request(
        API_URL,
        method="GET",
        headers={"xi-api-key": api_key},
    )

    try:
        with urllib.request.urlopen(request, context=ssl.create_default_context()) as response:
            payload = json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as error:
        error_body = error.read().decode("utf-8", errors="replace")
        print(f"HTTP {error.code}")
        print(error_body)
        return 1
    except urllib.error.URLError as error:
        print(f"Request failed: {error}")
        return 1

    character_count = payload.get("character_count")
    character_limit = payload.get("character_limit")
    voice_limit = payload.get("voice_limit")
    voice_slots_used = payload.get("voice_slots_used")

    print(f"tier: {payload.get('tier', 'N/A')}")
    print(f"status: {payload.get('status', 'N/A')}")
    print(f"character_count: {character_count}")
    print(f"character_limit: {character_limit}")
    if isinstance(character_count, int) and isinstance(character_limit, int):
        print(f"character_remaining: {character_limit - character_count}")
    print(f"can_extend_character_limit: {payload.get('can_extend_character_limit', 'N/A')}")
    print(f"allowed_to_extend_character_limit: {payload.get('allowed_to_extend_character_limit', 'N/A')}")
    print(f"max_character_limit_extension: {payload.get('max_character_limit_extension', 'N/A')}")
    print(f"next_character_count_reset: {format_reset_time(payload.get('next_character_count_reset_unix'))}")
    print(f"voice_limit: {voice_limit}")
    print(f"voice_slots_used: {voice_slots_used}")
    if isinstance(voice_limit, int) and isinstance(voice_slots_used, int):
        print(f"voice_slots_remaining: {voice_limit - voice_slots_used}")
    print(f"raw_json: {json.dumps(payload, ensure_ascii=False)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
