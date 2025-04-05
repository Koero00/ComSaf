/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const sendLocationNotification = functions.https.onCall(
  async (data, context) => {
    const receiverId = data.data.receiverId;
    const senderId = data.data.senderId;
    const lat = data.data.lat;
    const long = data.data.long;

    if (!receiverId || !senderId || !lat || !long) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing required params"
      );
    }

    const userDoc = await admin
      .firestore()
      .collection("users")
      .doc(receiverId)
      .get();

    const fcmToken = userDoc.data()?.fcmToken;

    if (!fcmToken) {
      throw new functions.https.HttpsError(
        "not-found",
        "FCM token not found for receiver"
      );
    }

    const message = {
      token: fcmToken,
      notification: {
        title: "Location Alert",
        body: `User ${senderId} shared their location.`,
      },
      data: {
        sender_id: senderId,
        lat: lat.toString(),
        long: long.toString(),
      },
    };

    await admin.messaging().send(message);

    return {success: true};
  }
);

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
