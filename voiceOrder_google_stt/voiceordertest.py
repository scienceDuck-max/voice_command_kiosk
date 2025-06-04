#export GOOGLE_APPLICATION_CREDENTIALS="/Users/jbsong/Desktop/voiceOrderProject/voiceorder_madgenerator_key.json"

# Imports the Google Cloud client library
'''
from google.cloud import speech

# Instantiates a client
client = speech.SpeechClient()

# The name of the audio file to transcribe
gcs_uri = "gs://cloud-samples-data/speech/brooklyn_bridge.raw"

audio = speech.RecognitionAudio(uri=gcs_uri)

config = speech.RecognitionConfig(
    encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
    sample_rate_hertz=16000,
    language_code="en-US",
)

# Detects speech in the audio file
response = client.recognize(config=config, audio=audio)

for result in response.results:
    print("Transcript: {}".format(result.alternatives[0].transcript))
'''

from google.cloud import speech
from pydub import AudioSegment
import numpy as np
import io
import socket

## 빵형 제작당시(20.07.06)보다 라이브러리 업뎃이 진행되어 아래는 맞지 않는다.
# from google.cloud import speech_v1
# from google.cloud.speech_v1 import enums
# from pydub import AudioSegment
# import numpy as np
# import io

def sample_recognize(local_file_path):
    client = speech.SpeechClient()

    language_code = "ko-KR"
    sample_rate_hertz = 44100

    encoding = speech.RecognitionConfig.AudioEncoding.ENCODING_UNSPECIFIED
    config = speech.RecognitionConfig(
        encoding=encoding,
        sample_rate_hertz=sample_rate_hertz,
        language_code=language_code,
        enable_word_time_offsets=True,
        use_enhanced=True
    )
## Old ver.
#     encoding = enums.RecognitionConfig.AudioEncoding.ENCODING_UNSPECIFIED
#     config = {
#         "language_code": language_code,
#         "sample_rate_hertz": sample_rate_hertz,
#         "encoding": encoding,
#         "enable_word_time_offsets": True,
#         "use_enhanced": True,
#     }
    
    with io.open(local_file_path, "rb") as f:
        content = f.read()
    
    ## Old ver.
#     audio = {"content": content}
    audio = speech.RecognitionAudio(content=content)
    response = client.recognize(config=config, audio=audio)
    
    if len(response.results) > 0:
        first_result = response.results[0].alternatives[0]
        transcribed_text = first_result.transcript
        print("Transcript: {}".format(transcribed_text))
        return transcribed_text
    else:
        return "NULL"
    
    '''
    resultTest = ""
    for result in response.results:
        resultTest = resultTest + result.alternatives[0].transcript
        print("Transcript: {}".format(result.alternatives[0].transcript))
    
    #print(resultTest)
    return resultTest
    '''
    
def main():
    UDP_IP = "127.0.0.1"  # Listen on all available interfaces
    UDP_PORT = 12345

    # Create a UDP socket
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    # Bind the socket to the specified address and port
    server_socket.bind((UDP_IP, UDP_PORT))

    print("UDP server is listening on port", UDP_PORT)

    try:
        while True:
            # Receive data and client address from the socket
            data, client_address = server_socket.recvfrom(1024)

            # Print received data and client address
            print("Received data from client:", data.decode("utf-8"))
            print("Client address:", client_address)

            # Process the received data here (if needed)
            # ...

            # Example: Send a response back to the client
            rst = sample_recognize("./test.wav")
            response = rst+" "
            server_socket.sendto(response.encode("utf-8"), client_address)

    except KeyboardInterrupt:
        print("Server stopped by user.")

    finally:
        # Close the socket when done
        server_socket.close()


if __name__ == "__main__":
    main()