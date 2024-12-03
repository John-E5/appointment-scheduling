CREATE TABLE `regions` (
  `region_id` integer PRIMARY KEY,
  `region_name` varchar(255),
  `timezone` varchar(255),
  `data_retention_days` integer,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `clinics` (
  `clinic_id` integer PRIMARY KEY,
  `region_id` integer,
  `clinic_name` varchar(255),
  `address` text,
  `phone` varchar(255),
  `email` varchar(255),
  `created_at` timestamp
);

CREATE TABLE `users` (
  `user_id` integer PRIMARY KEY,
  `email` varchar(255),
  `password_hash` varchar(255),
  `user_type` enum,
  `status` enum,
  `created_at` timestamp,
  `last_login` timestamp
);

CREATE TABLE `patients` (
  `patient_id` integer PRIMARY KEY,
  `user_id` integer,
  `first_name` varchar(255),
  `last_name` varchar(255),
  `date_of_birth` date,
  `phone` varchar(255),
  `address` varchar(255),
  `insurance_info` text,
  `preferred_language` varchar(255),
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `medical_staff` (
  `staff_id` integer PRIMARY KEY,
  `user_id` integer,
  `clinic_id` integer,
  `first_name` varchar(255),
  `last_name` varchar(255),
  `staff_type` enum,
  `specialization` varchar(255),
  `license_number` text,
  `created_at` timestamp
);

CREATE TABLE `staff_availability` (
  `availability_id` integer PRIMARY KEY,
  `staff_id` integer,
  `day_of_week` integer,
  `start_time` time,
  `end_time` time,
  `is_recurring` boolean,
  `specific_date` date,
  `created_at` timestamp
);

CREATE TABLE `appointment_types` (
  `type_id` integer PRIMARY KEY,
  `name` varchar(255),
  `duration` integer,
  `requires_prescreening` boolean,
  `description` text,
  `created_at` timestamp
);

CREATE TABLE `appointments` (
  `appointment_id` integer PRIMARY KEY,
  `patient_id` integer,
  `doctor_id` integer,
  `nurse_id` integer,
  `appointment_type_id` integer,
  `clinic_id` integer,
  `scheduled_start` datetime,
  `scheduled_end` datetime,
  `status` enum,
  `cancellation_reason` text,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `prescreening_questions` (
  `question_id` integer PRIMARY KEY,
  `appointment_type_id` integer,
  `question_text` text,
  `is_required` boolean,
  `created_at` timestamp
);

CREATE TABLE `precreening_responses` (
  `response_id` integer PRIMARY KEY,
  `appointment_id` integer,
  `question_id` integer,
  `response_text` text,
  `created_at` timestamp
);

CREATE TABLE `appointment_history` (
  `history_id` integer PRIMARY KEY,
  `appointment_id` integer,
  `action_type` enum,
  `action_by` integer,
  `previous_status` varchar(255),
  `new_status` varchar(255),
  `notes` text,
  `created_at` timestamp
);

CREATE TABLE `notifications` (
  `notification_id` integer PRIMARY KEY,
  `user_id` integer,
  `appointment_id` integer,
  `type` enum,
  `status` enum,
  `channel` enum,
  `content` text,
  `sent_at` timestamp,
  `created_at` timestamp
);

ALTER TABLE `clinics` ADD FOREIGN KEY (`region_id`) REFERENCES `regions` (`region_id`);

ALTER TABLE `patients` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `medical_staff` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `medical_staff` ADD FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`clinic_id`);

ALTER TABLE `staff_availability` ADD FOREIGN KEY (`staff_id`) REFERENCES `medical_staff` (`staff_id`);

ALTER TABLE `appointments` ADD FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`);

ALTER TABLE `appointments` ADD FOREIGN KEY (`doctor_id`) REFERENCES `medical_staff` (`staff_id`);

ALTER TABLE `appointments` ADD FOREIGN KEY (`nurse_id`) REFERENCES `medical_staff` (`staff_id`);

ALTER TABLE `appointments` ADD FOREIGN KEY (`appointment_type_id`) REFERENCES `appointment_types` (`type_id`);

ALTER TABLE `appointments` ADD FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`clinic_id`);

ALTER TABLE `prescreening_questions` ADD FOREIGN KEY (`appointment_type_id`) REFERENCES `appointment_types` (`type_id`);

ALTER TABLE `precreening_responses` ADD FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`);

ALTER TABLE `precreening_responses` ADD FOREIGN KEY (`question_id`) REFERENCES `prescreening_questions` (`question_id`);

ALTER TABLE `appointment_history` ADD FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`);

ALTER TABLE `appointment_history` ADD FOREIGN KEY (`action_by`) REFERENCES `medical_staff` (`staff_id`);

ALTER TABLE `notifications` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `notifications` ADD FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`);
