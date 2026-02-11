# Project Overview & Implementation Guide

This document summarizes the application flow, API integration, and the technical solutions implemented to solve the "Flutter Web Refresh" issue.

## **1. Application Flow**
- **Authentication Check**: On startup, the `AppRouter` (GoRouter) checks the user's login state via `AuthController`.
- **Navigation Flow**:
  - Unauthenticated: Splash Screen → Login → Signup.
  - Authenticated: Home Screen (Movie List) → Movie Details.
- **State Management**: Uses **GetX** for dependency injection and reactive state updates.
- **Routing**: Uses **GoRouter** for web-friendly URL handling (e.g., `/movie-details/123`).

## **2. API & Data Flow**
- **External API**: Integrates with **TMDB (The Movie Database)** using Bearer Token authentication.
- **Network Layer**: `NetworkApiService` (core) handles HTTP requests (GET/POST) and error handling.
- **Repository Pattern**: `MovieRepository` abstracts the API calls into clean methods like `getUpcomingMovies()` and `getMovieDetails(id)`.
- **Controller Layer**: `MovieController` calls the repository, manages the observable list (`.obs`), and handles loading/error states.

## **3. The "Web Refresh" Problem**
In Flutter Web, refreshing the browser normally causes the app state to reset.
- **Problem 1**: The app would reset to the Splash screen because the initial auth check was visual.
- **Problem 2**: On the Movie Details page, the movie data (passed as an object) would be lost, showing "Movie not found".
- **Problem 3**: URL path parameters were not being utilized, making deep-linking impossible.

## **4. Technical Solutions Implemented**

### **A. URL Deep Linking & Path Parameters**
- **Implementation**: Converted the movie details route to use a path parameter: `/movie-details/:id`.
- **Benefit**: This allows the browser to remember exactly which movie was being viewed even after a refresh.
- **File Reference**: [app_router.dart](file:///d:/flutterProjects/Akmal/webflow_auth_app/lib/app/routes/app_router.dart)

### **B. Background Auth Recovery**
- **Implementation**: Modified the GoRouter `redirect` logic to handle the "initialization" state silently.
- **Benefit**: Prevents the "flash" of the splash screen or login screen when a user refreshes an authenticated page.
- **File Reference**: [app_router.dart](file:///d:/flutterProjects/Akmal/webflow_auth_app/lib/app/routes/app_router.dart)

### **C. Reactive Data Recovery**
- **Implementation**: 
  - Added `fetchMovieById(id)` to the controller to fetch data from the API if the local list is empty (common after refresh).
  - Used `Obx` in the UI to show a loading spinner while the background fetch completes.
- **Benefit**: Users no longer see "Movie not found" or broken data fields after a refresh.
- **File Reference**: [movie_controller.dart](file:///d:/flutterProjects/Akmal/webflow_auth_app/lib/features/auth/presentation/controllers/movie_controller.dart) and [movie_details_screen.dart](file:///d:/flutterProjects/Akmal/webflow_auth_app/lib/features/auth/presentation/pages/movies/movie_details_screen.dart)

### **D. Robust Repository Design**
- **Implementation**: Refactored `MovieRepository` to include direct detail fetching and fixed syntax/scope errors.
- **Benefit**: Ensures the app can always retrieve data for a specific ID, which is critical for deep-linking.
- **File Reference**: [movie_repository.dart](file:///d:/flutterProjects/Akmal/webflow_auth_app/lib/features/domain/repositories/movie_repository.dart)

## **5. Key Talking Points for Interview**
- "I implemented **GoRouter** with **Path Parameters** to ensure the app state is reflected in the URL."
- "I used the **Repository Pattern** to decouple the API logic from the UI, making the app more maintainable."
- "I solved the **State Persistence** issue on Web by implementing a background data recovery flow in the `initState` and using reactive state with **GetX**."
- "I handled **Edge Cases** like 'Obx improper use' by ensuring every reactive widget has a valid subscription to the controller's state."
