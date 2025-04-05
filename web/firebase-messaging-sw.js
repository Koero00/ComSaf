// Import Firebase scripts
importScripts('https://www.gstatic.com/firebasejs/9.22.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.22.1/firebase-messaging-compat.js');

// Initialize Firebase (use your actual config)
firebase.initializeApp({
  apiKey: "AIzaSyDuoW6i41swB5Yx-AgzwJg0bBjhJ4dkssA",
  authDomain: "helpin-f61b5.firebaseapp.com",
  projectId: "helpin-f61b5",
  storageBucket: "helpin-f61b5.firebasestorage.app",
  messagingSenderId: "1008998888109",
  appId: "1:1008998888109:web:88dffedee927b54f6a8c24",
  measurementId: "G-JJ7T0JRM5F"
});

// Retrieve messaging
const messaging = firebase.messaging();