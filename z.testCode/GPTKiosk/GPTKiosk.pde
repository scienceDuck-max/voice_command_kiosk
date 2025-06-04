import processing.core.*;
import java.io.*;
import java.net.*;
import processing.core.*;
import processing.data.*;

String prompt = "what is the full name of microsoft ceo in 2022?";
String apiKey = "OPEN_API_KEY";

public void settings() {
    size(400, 300);
}

public void setup() {
    println("[QUESTION] "+prompt);
    sendRequest(prompt);
}

public void draw() {
    // Additional logic if needed
}

public void sendRequest(String prompt) {
    try {
        URL url = new URL("https://api.openai.com/v1/chat/completions");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Authorization", "Bearer " + apiKey);
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setDoOutput(true);

        String requestBody = "{\"model\": \"gpt-3.5-turbo-0613\",\"messages\":[{\"role\":\"assistant\",\"content\":\"" + prompt + "\"}]}";
        OutputStream outputStream = connection.getOutputStream();
        outputStream.write(requestBody.getBytes());
        outputStream.flush();
        outputStream.close();

        int responseCode = connection.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            String responseLine;
            StringBuilder response = new StringBuilder();

            while ((responseLine = reader.readLine()) != null) {
                response.append(responseLine);
            }

            reader.close();
            
            String jsonString = response.toString();
            handleResponse(jsonString); //handling chatGPT output (json parsing)
        } else {
            System.out.println("Request failed with response code: " + responseCode);
        }

        connection.disconnect();
    } catch (IOException e) {
        e.printStackTrace();
    }
}

public void handleResponse(String response) {
    // Process the response here
    JSONObject json = parseJSONObject(response);
    if (json != null) {
      JSONArray choices = json.getJSONArray("choices");
      if (choices != null) {
        for (int i = 0; i < choices.size(); i++) {
          JSONObject choice = choices.getJSONObject(i);
          JSONObject message = choice.getJSONObject("message");
          String ans = message.getString("content");
          println("[ANSWER FINAL] "+ans);
        }
      }
      
    } 
    else {
      println("Invalid JSON string");
    }
}
