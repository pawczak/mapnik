settings =
{
    plugins =
    {
        ["plugin.openssl"] = { publisherId = "com.coronalabs" },
    },
    android =
    {
        usesPermissions =
        {
            "android.permission.INTERNET",
            "android.permission.READ_EXTERNAL_STORAGE"
        },
    },
    orientation = { supported = { "landscapeLeft", "landscapeRight", "portraitUpsideDown", "portrait" } }
}