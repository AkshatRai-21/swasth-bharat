Swasth Bharat

Welcome to Our App! This is a brief description of what the app does.

Swasth Bharat is a mobile application designed to streamline the process of booking medical appointments with doctors. Developed using Flutter for the front-end, Node.js with Express.js for the back-end, and MongoDB for data storage, this app aims to enhance accessibility to healthcare services by integrating various modern technologies.

Features
User Registration & Login: Secure registration and authentication for both patients and doctors.
Doctor Availability: Search for doctors by specialty and view their availability.
Location-Based Search: Find doctors near your location with proximity sorting.
Appointment Booking: Schedule appointments and receive confirmation notifications.
Conflict Resolution: Prevent double bookings and conflicting schedules.
Notifications: Get appointment reminders and driving directions via Google Maps.
Reviews & Ratings: Rate and review doctors based on your experience.
Payment Integration: Process payments using Apple Pay and Google Pay.
Blockchain Security: Securely store and access patient medical reports using blockchain technology.
In-App Recommendations: Personalized health suggestions powered by Firebase ML Kit.
Tech Stack
Front-End: Flutter
Back-End: Node.js with Express.js
Database: MongoDB
Blockchain: For secure storage of patient records
Machine Learning: Firebase ML Kit
Maps Integration: Google Maps API
Payment: Apple Pay and Google Pay


You can download the latest version of the app by clicking the link below:
[Download APK]([https://github.com/yourusername/yourrepository/releases/download/v1.0.0/myapp.apk](https://github.com/AkshatRai-21/swasth-bharat/releases/tag/v.1.0))


## Features

# register
![register](https://github.com/user-attachments/assets/30a44e86-85b3-4256-8ff2-899d65616a5a)

# signin
![signin](https://github.com/user-attachments/assets/c41ed244-1ce5-4548-95b9-e3839c9f274f)

# select doctors
https://github.com/AkshatRai-21/swasth-bharat/issues/10#issue-2459952164

# read about doctor and book appointemnt
![doctor description and appointment](https://github.com/user-attachments/assets/5300cd84-a92f-4fe7-8696-c8ba24d1fc33)

# select appointment slots
![select appointment slopts](https://github.com/user-attachments/assets/2c11726d-20ea-4c04-8b95-bd313e94fe9b)

# select slots
![slots](https://github.com/user-attachments/assets/ecd34c82-20c6-4b93-962d-a30a9831703f)

# search doctors
![search doctors](https://github.com/user-attachments/assets/18b033ed-58ee-4e2f-b293-203a27c21243)

# availability of all doctors basis their specialty
![doctor by specialty](https://github.com/user-attachments/assets/348785aa-1835-4a12-93ab-c92cb4a3479a)

# doctors near your location with doctors list sorted basis the shortest distance
![doctor by location](https://github.com/user-attachments/assets/06a95cd0-76f6-492f-ad67-e519b660cdb7)

# appointment details on home page
![appointment details](https://github.com/user-attachments/assets/c3dba47c-7163-4a56-bf6d-44986ab35333)

# appointment notification
![appopointment notification](https://github.com/user-attachments/assets/eb8958fa-e342-4465-93af-7bf953087ead)


## Backend Deployment
Our backend is deployed on Render. You can access it using the following base URL:
**Base URL:**  https://swastha-bharat-backend.onrender.com/

## API Endpoints

### User Authentication and Management

- **POST** `/userAuth/signin`  
  Description: Sign in a user.

- **POST** `/userAuth/signup`  
  Description: Sign up a new user with validation.

- **POST** `/userAuth/tokenIsValid`  
  Description: Check if the token is valid.

- **GET** `/userAuth/getUser`  
  Description: Retrieve the authenticated user's data.




### Doctor Authentication and Management

- **POST** `/api/doctors/signin`  
  Description: Sign in a doctor.

- **POST** `/api/doctors/signup`  
  Description: Sign up a new doctor.

- **POST** `/api/doctors/tokenIsValid`  
  Description: Check if the doctor's token is valid.

- **POST** `/api/doctors/getDoctor`  
  Description: Retrieve the authenticated doctor's data.  
  Note: This route is protected and requires admin privileges.

### Doctor Appointments and Scheduling

- **POST** `/api/doctors/:doctorId/saveDateTimeSlots`  
  Description: Save date and time slots for a doctor.

- **GET** `/api/doctors/:doctorId/availableDateTimeSlots`  
  Description: Fetch available date and time slots for a doctor.

- **DELETE** `/api/doctors/:doctorId/removeDateTimeSlot`  
  Description: Remove a specific date and time slot for a doctor.

### Doctor Directory and Search

- **GET** `/api/doctors/all`  
  Description: Retrieve all doctors.

- **GET** `/api/doctors/specialty`  
  Description: Retrieve doctors by specialty.

- **GET** `/api/doctors/near`  
  Description: Retrieve the nearest doctors.

- **GET** `/api/doctors/search-doctor`  
  Description: Search for doctors based on specific criteria.



### Appointments Management

- **POST** `/appointments`  
  Description: Create a new appointment.

- **GET** `/appointments/:userId`  
  Description: Retrieve all appointments for a specific user.

- **DELETE** `/delete/appointments/:id`  
  Description: Delete an appointment by its ID.

### Notifications Management

- **POST** `/user/notifications/push-notification`  
  Description: Send a push notification to a user.

- **POST** `/user/notifications/add`  
  Description: Add a new notification.

- **POST** `/user/notifications/schedule`  
  Description: Schedule a notification for a specific time.

- **POST** `/user/notifications/update`  
  Description: Update the status of a notification.

- **GET** `/user/notifications/:userId`  
  Description: Retrieve all notifications for a specific user.

- **DELETE** `/user/notifications/:notificationId`  
  Description: Delete a notification by its ID.

### Favorites Management

- **POST** `/favourites/add-favorite`  
  Description: Add a doctor to the user's favorites list.

- **POST** `/favourites/remove-favorite`  
  Description: Remove a doctor from the user's favorites list.

- **GET** `/favourites/favorites/:userId`  
  Description: Retrieve the user's list of favorite doctors.


