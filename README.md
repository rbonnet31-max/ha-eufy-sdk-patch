# ha-eufy-sdk-patch

Temporary Home Assistant add-on: the official [eufy-sdk bridge](https://github.com/mega-yfue/ha-eufy-sdk-addon) 0.5.0 image with one fix applied to `@mega-yfue/eufy-sdk` 0.4.0.

**Fix:** the P2P level-2 ECC key cache (`CommandRouter.cipherKeyCache`) was keyed by `cipher_id` alone. A `cipher_id` is only unique per account, so when a station shared from another account and one of your own stations use the same id, the second station gets the first one's key and fails with `level-2 key derivation failed (cipher_id N)` (no video, no commands). The cache is now keyed by `admin user | station | cipher_id`.

To be removed once the fix ships upstream.
