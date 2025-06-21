# voice_command_kiosk
voice order kiosk, openAI api + google stt


![alt text](https://github.com/scienceDuck-max/voice_command_kiosk/z.image/3.png)

## Overview  
This project is a voice-activated kiosk system for ordering coffee, developed using Processing and Python.  
Users can place their orders by speaking into a microphone, and the system converts the voice commands into structured JSON orders automatically.  
It leverages Google Cloud Speech-to-Text for audio transcription and OpenAI's ChatGPT API to interpret and format orders.

---

## Features  
- **Voice Recording & Playback:** Records audio input from a microphone and saves it to disk.  
- **UDP Communication:** Exchanges data between Processing (client) and a Python server for speech recognition.  
- **Speech-to-Text:** Uses Google Cloud Speech-to-Text API to convert recorded audio into text.  
- **Natural Language Processing:** Utilizes OpenAI’s GPT API to parse and convert freeform speech into structured JSON orders.  
- **Multi-Scene UI:** Includes multiple application scenes (START, MENU, CONFIRM, CHECK, END) to guide the user through the ordering process.  
- **Order Confirmation:** Displays the parsed order for user confirmation before finalizing.  

---

## Project Structure and Components

### 1. Processing Client  
- Handles UI rendering for different scenes with images and buttons.  
- Manages audio recording via the Minim library.  
- Sends recorded audio data or commands through UDP to the Python backend.  
- Receives JSON-formatted order responses from the Python server and updates UI scenes accordingly.  

### 2. Python Server  
- Listens on a UDP port for incoming requests from Processing.  
- Receives the recorded audio file saved by Processing and sends it to Google Cloud Speech-to-Text API for transcription.  
- Returns the transcribed text to the Processing client.  
- (Optional) Can send further requests to OpenAI API for order parsing if implemented in backend.  

### 3. Google Cloud Speech-to-Text  
- Transcribes Korean speech (or other configured languages) from audio files.  
- Supports enhanced models with word time offsets for better accuracy.  

### 4. OpenAI ChatGPT Integration  
- Processes the transcribed text to extract order details.  
- Converts natural language commands into JSON format specifying ordered items and quantities.  
- Enables flexible and dynamic understanding of user input beyond fixed commands.  

---

## How It Works - Step by Step

1. **Start Scene:** User launches the kiosk and sees the welcome screen.  
2. **Menu Scene:** User presses a button or key to start recording their order via microphone.  
3. **Recording:** Audio is recorded and saved locally by Processing.  
4. **UDP Transfer:** Processing signals the Python server to transcribe the audio.  
5. **Speech Recognition:** Python server uses Google Cloud API to transcribe speech to text.  
6. **Order Parsing:** The transcribed text is sent to OpenAI’s GPT to convert into structured JSON order data.  
7. **Order Confirmation:** The kiosk displays the interpreted order and asks the user to confirm.  
8. **Order Check:** User confirms or rejects the parsed order.  
9. **End Scene:** Upon confirmation, the order is finalized and the user is thanked; otherwise, they can retry.  

---

## Dependencies and Setup

- **Processing IDE** with libraries: Minim (audio), hypermedia.net (UDP)  
- **Python 3.x** environment with:  
  - `google-cloud-speech` library for STT  
  - `pydub`, `numpy` (optional, for audio processing)  
- **Google Cloud Account:** Enable Speech-to-Text API and download credentials JSON. Set environment variable:  
  export GOOGLE_APPLICATION_CREDENTIALS="path/to/credentials.json"  
- **OpenAI API Key:** Obtain from OpenAI and include in Processing code to call ChatGPT.  

---

## Notes

- Audio file is saved locally in the Processing sketch folder before sending to Python for transcription.  
- UDP is used for lightweight, fast communication between Processing and Python server running locally.  
- The system currently supports Korean language but can be configured for other languages by changing the Speech-to-Text language code.  
- The OpenAI prompt can be customized to better parse specific menu items or languages.  

---

## Future Improvements

- Add GUI elements for better user feedback during recording and order processing.  
- Extend the Python backend to handle full order parsing via ChatGPT instead of Processing.  
- Implement error handling for noisy audio or unrecognized speech.  
- Integrate payment and receipt generation modules for a complete kiosk system.  

---

