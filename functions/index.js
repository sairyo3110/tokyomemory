const functions = require("firebase-functions");
const admin = require('firebase-admin');
const axios = require('axios');
// Firebaseコンソール画面からダウンロードしたjsonファイル
const serviceAccount = require("./serviceAccountKey.json");

// FirebaseのAdminSDKの初期化
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

exports.register = functions.https.onCall(async (data, context) => {
    try {
        // アクセストークンをアプリ側から取得
        const token = data.token;

        // アクセストークンの有効性を検証
        const apiUrl = 'https://api.line.me/oauth2/v2.1/verify';
        const response = await axios.get(apiUrl, {
            params: {
                access_token: token,
            },
        });

        // ユーザーのプロフィールを取得(userID,displayName,pictureUrl)
        const url = 'https://api.line.me/v2/profile';
        const profile = await axios.get(url, {
            headers: {
                Authorization: `Bearer ${token}`,
            },
        });

        const profileData = profile.data;
        // userIdを使用してカスタムトークンを作成する
        const customToken = await admin.auth().createCustomToken(profileData.userId);
        // カスタムトークンをアプリ側に返す
        return { result: 'success', customToken: customToken };
    } catch (error) {
        return { result: 'error' };
    }
});