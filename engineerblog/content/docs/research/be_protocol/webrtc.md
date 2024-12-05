---
title: "WebRTC - Draft"
weight: 5
date: 2023-11-15T01:47:46+07:00
---

# WebRTC

Web Real-Time Communication

## Overview

- A protocol that connects peer to peer
- Find a peer to peer path to exchange video and audio in an efficient and low latency manner
- Standardized API
- Enables rich communications browsers, mobile, IOT devices


## Demo

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>WebRTC Manual SDP Exchange</title>
</head>
<body>
  <h1>WebRTC Manual SDP Exchange</h1>

  <div>
    <h3>Client 1 (Create Offer)</h3>
    <button id="startChannel">Start Channel</button>
    <textarea id="offerSDP" readonly placeholder="SDP Offer" style="width: 100%; height: 100px;"></textarea>
  </div>
  
  <div>
    <h3>Client 2 (Enter Offer and Respond)</h3>
    <textarea id="offerInput" placeholder="Paste SDP Offer Here" style="width: 100%; height: 100px;"></textarea>
    <button id="respondOffer">Respond to Offer</button>
    <textarea id="answerSDP" readonly placeholder="SDP Answer" style="width: 100%; height: 100px;"></textarea>
  </div>

  <div>
    <h3>Client 1 (Set SDP Answer)</h3>
    <textarea id="answerInput" placeholder="Paste SDP Answer Here" style="width: 100%; height: 100px;"></textarea>
    <button id="setAnswer">Set Answer</button>
  </div>

  <div>
    <h3>Communication</h3>
    <textarea id="chatArea" readonly style="width: 100%; height: 150px;"></textarea>
    <br />
    <input type="text" id="messageInput" placeholder="Type a message..." style="width: 80%;" />
    <button id="sendMessage" disabled>Send</button>
  </div>

  <script src="webrtc-demo.js"></script>
</body>
</html>
```

```js
const startChannelButton = document.getElementById('startChannel');
const offerSDPTextarea = document.getElementById('offerSDP');
const offerInputTextarea = document.getElementById('offerInput');
const respondOfferButton = document.getElementById('respondOffer');
const answerSDPTextarea = document.getElementById('answerSDP');
const answerInputTextarea = document.getElementById('answerInput');
const setAnswerButton = document.getElementById('setAnswer');
const sendButton = document.getElementById('sendMessage');
const chatArea = document.getElementById('chatArea');
const messageInput = document.getElementById('messageInput');

let localConnection, remoteConnection, sendChannel, receiveChannel;

// Start channel and create SDP offer (Client 1)
startChannelButton.onclick = async () => {
  localConnection = new RTCPeerConnection();

  // Create data channel
  sendChannel = localConnection.createDataChannel('chat');
  sendChannel.onopen = handleChannelStatusChange;
  sendChannel.onclose = handleChannelStatusChange;

  // Handle ICE candidates
  localConnection.onicecandidate = e => {
    if (!e.candidate) {
      offerSDPTextarea.value = JSON.stringify(localConnection.localDescription);
    }
  };

  // Create an SDP offer
  const offer = await localConnection.createOffer();
  await localConnection.setLocalDescription(offer);
};

// Respond to offer and create SDP answer (Client 2)
respondOfferButton.onclick = async () => {
  const offer = JSON.parse(offerInputTextarea.value);

  remoteConnection = new RTCPeerConnection();
  remoteConnection.onicecandidate = e => {
    if (!e.candidate) {
      answerSDPTextarea.value = JSON.stringify(remoteConnection.localDescription);
    }
  };

  // Handle incoming data channel
  remoteConnection.ondatachannel = e => {
    receiveChannel = e.channel;
    receiveChannel.onmessage = handleReceiveMessage;
    receiveChannel.onopen = handleChannelStatusChange;
    receiveChannel.onclose = handleChannelStatusChange;
  };

  // Set remote description from offer
  await remoteConnection.setRemoteDescription(offer);

  // Create an SDP answer
  const answer = await remoteConnection.createAnswer();
  await remoteConnection.setLocalDescription(answer);
};

// Set SDP answer on Client 1
setAnswerButton.onclick = async () => {
  const answer = JSON.parse(answerInputTextarea.value);
  if (localConnection) {
    await localConnection.setRemoteDescription(answer);
  }
};

// Send messages
sendButton.onclick = () => {
  const message = messageInput.value.trim();
  if (message && sendChannel.readyState === 'open') {
    sendChannel.send(message);
    appendMessage(`You: ${message}`);
    messageInput.value = '';
  }
};

// Append messages to chat area
function appendMessage(message) {
  chatArea.value += `${message}\n`;
}

// Handle received messages
function handleReceiveMessage(event) {
  appendMessage(`Peer: ${event.data}`);
}

// Handle channel status changes
function handleChannelStatusChange() {
  if (sendChannel && sendChannel.readyState === 'open') {
    messageInput.disabled = false;
    sendButton.disabled = false;
  } else {
    messageInput.disabled = true;
    sendButton.disabled = true;
  }
}
```
