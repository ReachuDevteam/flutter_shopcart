# Flutter Mobile Application Demo Documentation

---

## **Setting Up a Flutter Project for iOS**

### **Creating a Flutter Project**

1. **Install Flutter**: First, ensure that Flutter is installed on your system. You can download it from Flutter's official website.  [https://docs.flutter.dev/get-started/install/macos/mobile-ios?tab=download](https://docs.flutter.dev/get-started/install/macos/mobile-ios?tab=download)
2. **Create a New Project**: Open a terminal and execute the following command to create a new Flutter project:
    
    ```bash
    flutter create {PROJECT_NAME}
    ```
    
    This command generates a new Flutter project named **`demo2`**.
    
3. **Open the Project in an IDE**: Navigate to the project directory and open it with your preferred IDE (VS Code, Android Studio, etc.).

---

### **Understanding Dependencies and Assets**

**Dependencies** are external packages that your project relies on. These can be Flutter plugins, libraries, or frameworks added to your project to extend its functionality. For example, to add GraphQL support, you'd include **`graphql_flutter`** in your **`pubspec.yaml`** file under **`dependencies`**.

**Assets** are the resources your project uses, like images, fonts, and configuration files. These are also defined in your **`pubspec.yaml`** file and can be accessed throughout your project at runtime.

To include dependencies in your Flutter project, follow these steps, detailed here in English for documentation purposes:

1. **Open Your `pubspec.yaml` File**: This file is located at the root of your Flutter project. It's used to define the project and manage the dependencies, assets, and other configurations.
2. **Adding Dependencies**: Under the **`dependencies:`** section, list each dependency you want to include in your project along with the version numbers. Here's a basic structure:
    
    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      package_name: ^version_number
    ```
    
    - **`flutter`**: This entry is mandatory for every Flutter project, signifying that your project depends on the Flutter SDK.
    - **`package_name`**: Replace this with the actual name of the package you wish to add.
    - **`^version_number`**: Replace this with the version number of the package. The caret symbol (**`^`**) before the version number tells Dart to automatically update the package if updates are available that do not include breaking changes.
3. **Install the Dependencies**: After adding the dependencies to **`pubspec.yaml`**, run the following command in your terminal:
    
    ```arduino
    flutter pub get
    ```
    
    This command downloads the specified dependencies and their dependencies, making them available in your project.
    
4. **Importing Packages**: Once the dependencies are added and installed, you can import them into your Dart files using the **`import`** statement, like so:
    
    ```dart
    import 'package:package_name/package_name.dart';
    ```
    
5. **Using the Packages**: After importing the packages, you can start using the functionalities provided by the packages in your application code.

Remember, managing dependencies is a critical part of Flutter development. It allows you to leverage existing libraries and frameworks, reducing development time and effort. Always ensure you're using compatible versions to avoid conflicts and build issues.

### Example **`pubspec.yaml`**:

```yaml

name: demo2
description: A new Flutter project.

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: ">=2.12.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  graphql_flutter: ^5.0.0
  flutter_dotenv: ^5.0.2
  provider: ^5.0.0
  uuid: ^3.0.4
  webview_flutter: ^2.0.12
  flutter_stripe: ^1.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^1.0.0

flutter:
  uses-material-design: true
  assets:
    - .env
    - assets/images/

```

- **flutter**: This dependency includes the Flutter SDK itself, which is essential for any Flutter project.
- **graphql_flutter**: A GraphQL client for Flutter, enabling you to execute queries, mutations, and subscriptions. It's used for interacting with GraphQL servers.
- **flutter_dotenv**: This package allows you to load configuration variables at runtime from a **`.env`** file, which is useful for hiding sensitive information such as API keys and endpoints from your source code.
- **provider**: A state management package recommended by the Flutter team. It's used to efficiently manage the state of your app across different screens and widgets.
- **uuid**: A library for generating universally unique identifiers (UUID). Useful for creating unique keys, IDs, or any other items that require a unique value.
- **webview_flutter**: Provides a widget for embedding web content in your app. It's useful for displaying web pages or web applications directly within your Flutter application.
- **flutter_stripe**: A package that integrates Stripe's services into your Flutter app. It allows you to add payment processing features, making it easier to handle transactions securely.
- **cupertino_icons**: This package includes a set of Cupertino (iOS-style) icons. It's typically included by default in new Flutter projects for use in designing iOS-like interfaces.

---

### **Understanding Assets in Flutter**

Assets are the resources that an application needs to run, including but not limited to images, fonts, and configuration files. In Flutter, managing assets is crucial for building rich, engaging applications. Here's an overview of how assets are used and managed in Flutter projects.

### Types of Assets

1. **Images**: Visual elements that enhance the user interface. They can be in various formats such as JPEG, PNG, GIF, etc.
2. **Icons**: Small graphical representations used throughout the app. Flutter includes a library of predefined icons, but you can also use custom icons.
3. **Fonts**: Custom fonts allow you to maintain consistent typography across your application.
4. **Configuration Files**: Files like JSON or XML that contain configuration data or initial data for the app.

### Adding Assets to Your Flutter Project

To use assets in your Flutter project, you need to declare them in the **`pubspec.yaml`** file, which is located at the root of your project. This YAML file contains metadata about your project, including its dependencies and assets.

### **Example: Adding an Image Asset**

```yaml
flutter:
  assets:
    - assets/images/logo.png

```

This tells Flutter that there's an image called **`logo.png`** located in the **`assets/images/`** directory of your project, and it should be included when the app is packaged.

---

### **Environment Variables**

Environment variables store configuration outside your codebase, like API keys and endpoint URLs. They help keep sensitive information secure and make your app more configurable without code changes. Use the **`flutter_dotenv`** package to load environment variables from a **`.env`** file at runtime.

Example **`.env`** file:

```makefile
API_TOKEN= "E2YNHFE-2X648T6-HR9S8FX-79PEZK7"
GRAPHQL_SERVER_URL="https://graph-ql-dev.reachu.io"
STRIPE_PUBLISHABLE_KEY="pk_test_51MvQONBjfRnXLEB43vxVNP53LmkC13ZruLbNqDYIER8GmRgLX97vWKw9gPuhYLuOSwXaXpDFYAKsZhYtBpcAWvcy00zQ9ZES0L"
REACHU_SERVER_URL="https://api-qa.reachu.io"
FAKE_RETURN_URL="https://www.example.com/confirmation.html"
```

### API_TOKEN

- **Purpose**: Used to authenticate requests to the GraphQL server or any other server requiring access tokens.
- **Typical Usage**: Included in the headers of HTTP requests to verify the requester's identity and grant access to protected resources.

### GRAPHQL_SERVER_URL

- **Purpose**: Specifies the URL of the GraphQL server.
- **Typical Usage**: Acts as the base endpoint for all GraphQL operations, such as queries and mutations, making it easy to configure the GraphQL client within the application.

### STRIPE_PUBLISHABLE_KEY

- **Purpose**: Used for integrating with Stripe services, specifically for making secure transactions and handling payments.
- **Typical Usage**: Necessary for initializing the Stripe SDK within the app, allowing it to communicate with Stripe's APIs for payment processing. This key is used in the client-side code and is safe to be exposed.

### **REACHU_SERVER_URL**

- **Purpose**: Specifies the base URL of the Reachu API server. This variable is essential for connecting to the backend services provided by Reachu, enabling the app to fetch data, submit requests, and interact with the backend efficiently.
- **Typical Usage**: Utilized throughout the application wherever API requests to the Reachu server are made. It centralizes the endpoint configuration, making it simpler to update or switch environments (e.g., development, QA, production) by changing a single variable.

### **FAKE_RETURN_URL**

- **Purpose**: Defines a placeholder URL intended to simulate a redirect URL in payment processes or other scenarios requiring a return URL. This URL is used during testing or development stages to verify the behavior of redirects or callback mechanisms without the need for a live endpoint.
- **Typical Usage**: Primarily used in payment integration testing, such as with Klarna or Stripe, to simulate the process where the payment service redirects the user back to the application upon completing a transaction. It allows developers to test and handle the redirect logic, ensuring the app responds correctly to various outcomes of the payment process.

To use these in your Dart code:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
await dotenv.load(fileName: ".env");
final apiUrl = dotenv.env['API_URL'];
final apiKey = dotenv.env['API_KEY'];
```

---

### **Project Structure Overview**

A well-organized project structure is crucial for the maintainability and scalability of a Flutter application. Here's an overview of the common directories found in a Flutter project and their purposes:

- **`/conts`**: This directory is typically used for storing constants used throughout the application. Constants can include theme data, string values, and other immutable data that you want to be accessible across your app.
- **`/graphql`**: Contains GraphQL query, mutation, and subscription files. This is where you define the operations you want to perform on your GraphQL server, such as fetching data, updating data, or subscribing to data changes.
- **`main.dart`**: The entry point of the Flutter application. This file contains the **`main()`** function, which runs the app, and usually includes the root widget of your application.
- **`/models`**: Holds data models of your application. These models represent the data structure of objects in your app, often mirroring the data received from a backend or database.
- **`/screens`**: Contains the various screens of your app. Each screen is typically represented by a Dart file that defines a widget. Organizing screens into a separate directory helps in managing the user interface components of your app efficiently.
- **`/state`**: Used for state management files. If you're using a state management solution (like Provider, Bloc, Redux, etc.), this directory contains the logic for managing the state of your app. This includes classes and functions that help in distributing and managing the app's data.
- **`/widgets`**: Contains reusable widget files. Widgets that you use across multiple screens or components of your app can be defined here. Organizing common widgets into a separate directory makes them easily accessible and promotes code reuse.

---

### Code explanation

Sure, let's dive deeper into the functionality and design decisions of each screen and their components for a more comprehensive understanding.

### **Main Structure (`main.dart`)**

The **`main.dart`** file is the starting point of the Flutter application. It orchestrates the initial setup, including environment configuration, state management initialization, and routing.

- **UUID Generation:** A unique identifier (UUID) is generated every time the app starts. This UUID is pivotal for tracking the user's session and associating their actions, such as cart creation, with a unique session ID. This approach ensures that even anonymous users can interact with the cart without immediately requiring login credentials.
- **Environment Setup:** The application loads configurations from an **`.env`** file, utilizing **`dotenv`**. This method of managing environment variables allows for a clear separation of configuration and code, making the application more secure and adaptable to different deployment environments without code changes.
- **GraphQL Client Initialization:** Establishes a connection to the GraphQL API. The GraphQL client is essential for interacting with the backend, enabling the app to perform queries and mutations. This setup demonstrates a modern approach to data fetching, where GraphQL's efficient querying capabilities are leveraged for optimized network usage and simpler data management.
- **Global State Management:** Utilizes the Provider package for state management across the app. This design choice illustrates a reactive programming model where the UI automatically updates in response to state changes. It's particularly effective for managing shared state like the shopping cart, user preferences, and session data.

### **Checkout Process (`CheckoutScreen`)**

This screen is integral to the shopping flow, where users enter their billing and shipping information.

- **Dynamic Form Fields:** Adjusts its form fields dynamically based on the selected country. This adaptability enhances user experience by catering to international address formats and requirements, reducing user error and improving data accuracy for shipping and billing.
- **Form Validation and Submission:** Employs robust form validation to ensure that user inputs meet specific criteria before submission. This step is critical for maintaining data integrity and providing immediate feedback to users, improving the overall usability of the checkout process.
- **Conditional Field Display:** Incorporates logic to conditionally display or hide fields, such as state/province selection, based on the country's address structure. This attention to detail in UI/UX design demonstrates an understanding of internationalization challenges in web development.

### **Payment Selection and Processing Overview**

In a modern e-commerce or service-oriented application, offering a seamless and secure payment experience is pivotal. The **`PaymentScreen`** serves as the gateway for users to choose their preferred payment method, significantly enhancing user convenience and accessibility across different demographics and preferences.

### **Stripe Integration for Secure Payments**

**`StripePaymentCardWidget`** is a critical component designed to facilitate secure and efficient transactions using Stripe, a leading global payment processor. This integration demonstrates the application's commitment to providing a robust and user-friendly payment solution. Here are the key features and processes involved:

### Initial Setup and Payment Intent

- **Initialization**: The widget initializes the Stripe environment with the publishable API key, ensuring a secure handshake with Stripe's services.
- **Payment Intent Creation**: Initiates a payment intent on the server-side, which is essential for preparing the Stripe system to process a new payment, passing crucial information such as the payment amount, currency, and customer email.

### Payment Sheet Presentation

- **User Interface**: Dynamically presents a payment sheet to the user, populated with the necessary payment details and available payment methods. This step is critical for user engagement, offering a clear and concise interface for completing the transaction.
- **Payment Execution**: Handles user interactions with the payment sheet, including the selection of payment methods and the final authorization of the payment. This process is managed asynchronously, showcasing the application's capability to handle real-time transactions efficiently.

### Transaction Feedback and Error Handling

- **Success and Failure Handling**: Upon completion of the payment process, the widget captures and processes the outcome, providing immediate feedback to the user. This includes successful payment acknowledgments or detailed error messages, ensuring transparency and trust.
- **Error Resolution**: Implements comprehensive error handling mechanisms to address potential issues during the payment process, such as network failures, declined payments, or configuration errors. This proactive approach minimizes user frustration and supports troubleshooting.

### **Conclusion**

The integration of Stripe within the **`StripePaymentCardWidget`**, combined with the versatile payment selection offered by the **`PaymentScreen`**, underscores the application's sophistication in handling financial transactions. It exemplifies the implementation of advanced Flutter development techniques, secure API integration, and a user-centric design philosophy, ensuring a seamless and secure payment experience for all users.

This documentation aims to provide a thorough understanding of the application's payment infrastructure, highlighting its capability to support diverse payment methods while prioritizing security and user experience.

### **Klarna Integration for Flexible Payment Solutions**

Alongside Stripe, the integration of Klarna into the application further diversifies the payment options available to users, catering to a broader audience with preferences for Klarna's flexible payment solutions. **`KlarnaPaymentCardWidget`** plays a pivotal role in this integration, offering a seamless interface for Klarna transactions. Here's an in-depth look at its functionality and processes:

### Klarna Payment Initialization

- **Dynamic Payment Session Creation**: Initiates a Klarna payment session by interacting with the backend to generate a unique transaction identifier and fetch the Klarna HTML snippet or payment URL. This process is crucial for tailoring the payment experience to the specific transaction and user.
- **Environment Configuration**: Configures the payment environment based on Klarna's requirements, ensuring compliance and security standards are met. This includes setting up the necessary callbacks and state management to handle the Klarna payment lifecycle.

### Customized Payment Interface

- **WebView Integration**: Utilizes a WebView to render the Klarna payment interface directly within the application, offering a native and immersive payment experience. This approach allows users to complete their transactions without leaving the app, enhancing convenience and security.
- **Adaptive Payment Flow**: Dynamically adjusts the payment flow based on Klarna's response, supporting various scenarios such as direct payments, installment plans, or payment after delivery. This flexibility is key to accommodating user preferences and increasing conversion rates.

### Payment Completion and Status Handling

- **Payment Completion Detection**: Monitors the WebView for specific URL patterns or callbacks that indicate the completion of the payment process, successfully capturing the payment outcome.
- **Success and Error Feedback**: Provides clear and immediate feedback to the user based on the payment result, including successful confirmation or detailed error messages. This transparency is essential for building user trust and satisfaction.

### Klarna Specific Features

- **Seamless Integration**: The widget's design ensures that Klarna's payment interface is seamlessly integrated, maintaining the look and feel of the application while leveraging Klarna's robust payment processing capabilities.
- **Cross-Platform Compatibility**: Addresses the nuances of integrating Klarna across different platforms, ensuring a consistent and reliable payment experience regardless of the user's device.

### **Conclusion**

The **`KlarnaPaymentCardWidget`** represents a significant advancement in offering flexible and user-friendly payment options within the application. By integrating Klarna, the application not only broadens its appeal to users who prefer Klarna's payment solutions but also demonstrates its adaptability to incorporate multiple payment systems. This integration exemplifies sophisticated development practices, including secure backend interactions, dynamic content rendering within WebViews, and meticulous state management to ensure a smooth payment process from initiation to completion.

Together with Stripe, Klarna enriches the application's financial ecosystem, providing users with a comprehensive selection of payment methods tailored to their preferences and needs, all while upholding the highest standards of security and user experience.

### **Product Browsing (`ProductsScreen`)**

The **`ProductsScreen`** is where users explore available products.

- **Dynamic Product Listing:** Fetches and displays products dynamically based on the selected currency. This functionality illustrates effective state management and API integration, where product prices and details update in response to user actions like currency selection.
- **Lazy Loading:** Implements efficient data fetching and rendering techniques, potentially using lazy loading (if extended beyond the provided description), which improves performance and user experience by loading content as needed rather than all at once.

By delving into these specifics, we've highlighted not only the technical implementations but also the thoughtful design decisions aimed at creating a seamless and user-friendly e-commerce experience. These descriptions should provide a robust foundation for documenting the application's architecture and user flow.

**File:** **`GraphQLConfiguration.dart`**

This class configures and initializes the GraphQL client, setting up the connection to your GraphQL server. It demonstrates how to integrate GraphQL in a Flutter project using the **`graphql_flutter`** package.

```dart

class GraphQLConfiguration {
  static HttpLink httpLink = HttpLink(
    dotenv.env['GRAPHQL_SERVER_URL']!, // Fetches the GraphQL server URL from environment variables.
  );

  static AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer ${dotenv.env['API_TOKEN']}', // Retrieves the API token for authentication.
  );

  static Link link = authLink.concat(httpLink); // Combines the authentication link with the HTTP link.

  static ValueNotifier<GraphQLClient> clientToQuery() {
    return ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(), // Sets up a cache for query results.
        link: link, // Uses the combined link with authentication and HTTP request handling.
      ),
    );
  }
}

```

This configuration is crucial for securing API requests and managing the client-side cache, enhancing performance and user experience.

### **Creating Mutations**

**File:** **`CheckoutMutations.dart`**

This file contains several GraphQL mutations for handling checkout processes, such as creating and updating checkout sessions, initiating payments, and more.

```dart

class CheckoutMutations {
  // A mutation for creating a new checkout session.
  static const String createCheckoutMutation = '''
    mutation CreateCheckout($cartId: String!) {
      ...
    }
  ''';

  // Example function to execute the createCheckout mutation.
  static Future<Map<String, dynamic>?> createCheckout(GraphQLClient client, String cartId) async {
    ...
  }
}

```

These mutations show how to perform write operations against the GraphQL API, updating server-side data based on user actions, such as finalizing a purchase.

### **Querying Data**

**File:** **`ProductQueries.dart`**

This class demonstrates fetching product data using GraphQL queries. It highlights how to dynamically adjust the query based on user-selected options like currency.

```dart

class ProductQueries {
  static const String channelGetProductsQuery = """
    query ChannelGetProducts($currency: String, $imageSize: ImageSize) {
      ...
    }
  """;

  static Future<List<Product>> executeChannelGetProductsQuery(GraphQLClient client, {String? currency, String imageSize = 'large'}) async {
    ...
  }
}

```

These queries are vital for retrieving data to display in the app, ensuring the content is up-to-date and relevant to the user's context.

### **Stripe SDK Integration**

**File:** **`StripePaymentCardWidget.dart`**

This widget integrates the Stripe SDK for handling payments, showcasing the setup, payment sheet initialization, and user feedback mechanisms.

```dart

class StripePaymentCardWidget extends StatefulWidget {
  final String email;
  final double totalAmount;
  final String currency;
  ...

  Future<void> initPaymentSheet() async {
    ...
    // Initializes the payment sheet with Stripe's SDK.
  }

  Future<void> presentPaymentSheet() async {
    ...
    // Presents the payment sheet to the user for payment completion.
  }

  Widget paymentStatusWidget() {
    ...
    // Displays payment success or failure status.
  }
  ...
}

```

This widget exemplifies a modern payment flow in mobile applications, focusing on security, user experience, and seamless integration with backend services.

Each of these components plays a crucial role in the application's functionality, from securing and managing data communications with GraphQL to handling financial transactions safely with Stripe. The code snippets provided offer a practical look into implementing these features in a Flutter project, serving as a valuable reference for developers.

---

### Run and debug project

To run and debug a Flutter project in Visual Studio Code (VSCode) using the Xcode iOS simulator, follow these steps to ensure a smooth development experience. This guide assumes you have Flutter, VSCode, and Xcode installed on your macOS system.

### **Prerequisites:**

1. **Flutter SDK:** Ensure you have Flutter installed and added to your system's PATH.
2. **Visual Studio Code:** Install VSCode, if not already installed.
3. **Xcode:** Install Xcode from the Mac App Store to use the iOS simulator.
4. **VSCode Extensions:** Install the Flutter and Dart extensions in VSCode for Flutter support.

### **Running the Project:**

1. **Open the Project:**
    - Launch VSCode and use **`File > Open...`** to open your Flutter project folder.
2. **Select Target Device:**
    - In VSCode, look at the bottom right corner. You should see a device selection dropdown. Click on it and select an iOS simulator. You might need to start an iOS Simulator first through Xcode if none are listed. To do this, open Xcode, go to **`Xcode > Open Developer Tool > Simulator`**.
3. **Run the App:**
    - You can run the app by clicking on the green play icon in the top right corner of VSCode or by pressing **`F5`**. This action will build the app and launch it on the selected iOS simulator.
    - Alternatively, you can use the Terminal in VSCode (View > Terminal) and run the command **`flutter run`**.

### **Debugging the Project:**

- **Breakpoints:** To debug, you can set breakpoints in your code by clicking on the left side of the line numbers in your Dart files. A red dot will appear, indicating a breakpoint.
- **Start Debugging:** With breakpoints set, start your app in debug mode by pressing **`F5`** or by selecting **`Run > Start Debugging`** from the menu.
- **Inspect Variables:** When execution stops at a breakpoint, you can hover over variables to inspect their current state or use the Debug Side Bar to see a list of all variables and their values.
- **Step Through Code:** Use the debug toolbar (appears at the top of the window) to step over, into, or out of code lines and to continue execution.

### **Troubleshooting:**

- **Simulator Not Launching:** Ensure the Xcode command-line tools are selected for use. Open Terminal and run **`sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`** and try running the app again.
- **Build Errors:** Check the Flutter Doctor by running **`flutter doctor`** in the Terminal for any missing dependencies or issues.
- **Hot Reload Not Working:** Ensure your app is running in debug mode. Hot reload allows you to see changes almost instantly in the simulator without needing a full rebuild.

Following these steps will enable you to run and debug your Flutter app on an iOS simulator using VSCode. This setup is ideal for rapid development and testing of your Flutter applications on iOS platforms.

Let's delve into the critical components of your Flutter project, focusing on GraphQL integrations, state management, and Stripe SDK utilization, accompanied by code explanations to enrich your documentation.