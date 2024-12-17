#  Reco: SwiftUI Product Recommendation Demo

Project Overview

Reco is a SwiftUI-based demo application designed to showcase key skills in UI composition, data persistence, and network integration. The app provides personalized product recommendations based on user input and profile preferences, leveraging OpenAI's API for generating recommendations.

Purpose
This project demonstrates:

SwiftUI Composition: Modular and dynamic UI components.
Data Persistence: User profile and recommendation history stored using SwiftData.
Network Integration: Fetching data from OpenAI's API using structured JSON responses.
It serves as a practical example of clean architecture, MVVM design pattern, and SwiftUI best practices for modern iOS development.

Key Features

1. User Profile Management
Editable user profile for managing preferences:
Budget Sensitivity (0-1 scale)
Brand Loyalty (0-1 scale)
Data persistence using SwiftData.
2. Personalized Product Recommendations
Input queries to fetch relevant product recommendations.
Dynamic, animated Product Cards with compact and full-size layouts.
Mesh gradient backgrounds for aesthetic appeal.
3. Recommendation History
Saves previous recommendations with timestamps.
Tap to revisit and refine recommendations.
Option to delete individual recommendations or clear all history.
4. Integration with OpenAI API
OpenAI Chat Completions API fetches structured JSON responses based on queries.
Encapsulated API logic with robust error handling for decoding and network failures.
Technical Highlights

UI Composition (SwiftUI)
Dynamic Layouts: Product cards adapt to compact and full-size views.
Animations: Smooth transitions when toggling card states.
MeshGradient: Subtle background gradients enhance visual appeal and user focus.
Data Persistence (SwiftData)
UserProfile model: Stores user name, budget sensitivity, and brand loyalty.
Recommendation model: Captures product details like name, price, and image URL.
History Management: Saved recommendations can be revisited or cleared easily.
Networking (OpenAI API)
API encapsulated in APIClient.swift for clean separation of concerns.
Requests include structured prompts with user preferences.
Handles various error scenarios, including missing API keys, invalid responses, and connection issues.
Setup Instructions

Clone the repository.
Add a Secrets.plist file with your OpenAI API Key:
<?xml version="1.0" encoding="UTF-8"?>  
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">  
<plist version="1.0">  
<dict>  
    <key>OPENAI_API_KEY</key>  
    <string>Your-OpenAI-API-Key-Here</string>  
</dict>  
</plist>  
Rename the provided Secrets.plist.example file if needed for your project.
Run the project in Xcode.


What to Look For

Clean SwiftUI Composition: Modular and reusable components (ProductCard, UserProfileView).
SwiftData Integration: Seamless data persistence for user profiles and recommendations.
API Handling: Robust error handling and clean request/response structures.
UI/UX Details: Animated transitions, responsive layouts, gradients, and user-friendly navigation.
Notes for Reviewers

This project is designed to meet criteria for code examples:
UI Composition: SwiftUI-based layouts and animations.
Data Persistence: SwiftData implementation for profiles and recommendation history.
Networking: OpenAI API integration with clean and decodable JSON responses.
The code follows a modular structure, ensuring clean separation of concerns and scalability for future enhancements. Feel free to reach out for clarifications or additional examples.

Author

Corey Lofthus
corey@soulyftaudio.com | https://soulyftaudio.com
