import { initializeApp } from "https://www.gstatic.com/firebasejs/12.3.0/firebase-app.js";
import {
    fetchAndActivate,
    getRemoteConfig,
    getString,
} from "https://www.gstatic.com/firebasejs/12.3.0/firebase-remote-config.js";

const DEFAULT_PLAY_URL =
    "https://play.google.com/store/apps/details?id=co.za.zanderkotze.multichoice";
const REMOTE_CONFIG_KEY = "google_play_store_url";

const firebaseConfig = {
    apiKey: "AIzaSyC372YoDNVgDRW1VJEDLdKRA6HCNKEjS3s",
    authDomain: "multichoice-412309.firebaseapp.com",
    projectId: "multichoice-412309",
    storageBucket: "multichoice-412309.firebasestorage.app",
    messagingSenderId: "82796040762",
    appId: "1:82796040762:android:7d86369ea3e82786e4db03",
    measurementId: "G-RKRDGDJMDK",
};

const playStoreLink = document.getElementById("google-play-link");
const statusText = document.getElementById("remote-config-status");

const setPlayUrl = (url, sourceLabel) => {
    if (!playStoreLink || !url) {
        return;
    }

    playStoreLink.href = url;
    if (statusText) {
        statusText.textContent = sourceLabel;
    }
};

setPlayUrl(DEFAULT_PLAY_URL, "Available on Google Play.");

(async () => {
    try {
        const app = initializeApp(firebaseConfig);
        const remoteConfig = getRemoteConfig(app);

        remoteConfig.settings = {
            fetchTimeoutMillis: 10000,
            minimumFetchIntervalMillis: 3600000,
        };

        remoteConfig.defaultConfig = {
            [REMOTE_CONFIG_KEY]: DEFAULT_PLAY_URL,
        };

        await fetchAndActivate(remoteConfig);
        const remoteUrl = getString(remoteConfig, REMOTE_CONFIG_KEY).trim();

        if (remoteUrl.length > 0) {
            setPlayUrl(remoteUrl, "Available on Google Play.");
            return;
        }

        setPlayUrl(DEFAULT_PLAY_URL, "Available on Google Play.");
    } catch (_error) {
        setPlayUrl(DEFAULT_PLAY_URL, "Available on Google Play.");
    }
})();
