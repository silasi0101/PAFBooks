# PAFBooksApp

## Overview
PAFBooksApp is an iOS application developed with SwiftUI that displays a collection of books in a responsive grid view. The app retrieves book information from an external API, caches images locally for optimized loading, and provides a colorful placeholder background while images are loading.

## Features
- Book Grid View: Displays books in a 3-column grid with consistent spacing and a semi-transparent multi-colored placeholder.
- Image Caching: Utilizes NSCache and on-disk storage to cache images for smoother and faster loading.
- API Integration: Fetches data from a remote API endpoint to display book details dynamically.
- SwiftUI Components: Uses SwiftUI’s LazyVGrid and custom Color extensions for improved UI responsiveness and color variety.

## Project Structure
- Model: 
  - PAFBook: Defines the book model with properties such as id, title, language, thumbnail, publishedAt, and more.
- ViewModel: 
  - PAFBookViewModel: Manages fetching data from the API and publishes book data for use in the view.
- Image Loader:
  - PAFImageLoader: Handles image caching with NSCache for in-memory caching and on-disk storage for offline use.
- Views:
  - PAFBooksGridView: Displays the grid layout of books.
  - PAFImageView: Manages the display of each book's thumbnail, including placeholder color and caching.

## Requirements
- iOS: 14.0+
- Xcode: 12+
- Swift: 5.0+

## How to Run
1. Clone the repository.
2. Open the `.xcodeproj` file in Xcode.
3. Build and run the project on a simulator or a device.

## Usage
1. Launch the app.
2. The app fetches book data from the API and displays the books in a grid format.
3. Each book’s image loads with caching, so previously loaded images display immediately.

## API Details
The app fetches book data from the following API endpoint:
https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100

## Note
Ensure your device or simulator has internet access to fetch images from the API.
