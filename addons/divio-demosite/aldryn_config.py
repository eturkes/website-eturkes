# -*- coding: utf-8 -*-
try:
    from divio_cli import forms
except:
    from aldryn_client import forms


DEFAULT_DEMO_KEY_NAME = "demo_access_token"


class Form(forms.BaseForm):

    def to_settings(self, data, settings):
        from getenv import env

        settings["DEMO_ACCESS_TOKEN_KEY_NAME"] = env(
            "DEMO_ACCESS_TOKEN_KEY_NAME", DEFAULT_DEMO_KEY_NAME
        )
        settings["DEMO_ACCESS_SECRET_STRING"] = env(
            "DEMO_ACCESS_SECRET_STRING", None
        )
        settings["DEMO_MODE_ACTIVE"] = bool(
            (
                settings["DEMO_ACCESS_TOKEN_KEY_NAME"]
                and settings["DEMO_ACCESS_SECRET_STRING"]
            )
        )
        if settings["DEMO_MODE_ACTIVE"]:
            settings["CMSCLOUD_SYNC_KEY"] = None

        if not settings["DEMO_ACCESS_SECRET_STRING"]:
            return settings

        if env("STAGE") == "local":
            print(
                get_test_values(
                    "http://ip:port/", settings["SECRET_KEY"], "secret"
                )
            )

        # replace the sso middleware with our modified version if it exists
        if "aldryn_sso.middleware.AccessControlMiddleware" in settings[
            "MIDDLEWARE_CLASSES"
        ]:
            # replace the aldryn_sso middleware
            position = settings["MIDDLEWARE_CLASSES"].index(
                "aldryn_sso.middleware.AccessControlMiddleware"
            )
        else:
            position = settings["MIDDLEWARE_CLASSES"].index(
                "django.contrib.auth.middleware.AuthenticationMiddleware"
            ) + 1
        settings["MIDDLEWARE_CLASSES"].insert(
            position, "divio_demosite.middleware.DemoAccessControlMiddleware"
        )
        settings["INSTALLED_APPS"].append("divio_demosite")

        return settings


# DEMO_ACCESS_TOKEN_KEY_NAME and DEMO_ACCESS_SECRET_STRING are generated on
# the controlpanel. The methods below are just helpers for local testing
# and debugging.


def get_demo_access_secret_token(site_secret_key, secret):
    import hmac
    import hashlib
    return hmac.new(
        site_secret_key, msg=secret, digestmod=hashlib.sha256
    ).hexdigest()


def get_demo_access_secret_token_with_timeout(**kwargs):
    import django.core.signing

    timeout_s = kwargs.pop("timeout_s")
    signer = django.core.signing.Signer(get_demo_access_secret_token(**kwargs))
    token = str(signer.sign(timeout_s))
    return token


def get_demo_url(
    url,
    site_secret_key,
    secret,
    key_name=DEFAULT_DEMO_KEY_NAME,
    timeout_s=2 * 60
):
    import urllib

    token = get_demo_access_secret_token_with_timeout(
        site_secret_key=site_secret_key, secret=secret, timeout_s=timeout_s
    )
    query = urllib.urlencode({key_name: token, "edit": ""})
    url = "{}?{}".format(url, query)
    return url


def get_test_values(url, site_secret_key, secret):
    return {
        "DEMO_ACCESS_SECRET_STRING": get_demo_access_secret_token(
            site_secret_key, secret
        ),
        "DEMO_URL": get_demo_url(url, site_secret_key, secret),
    }
