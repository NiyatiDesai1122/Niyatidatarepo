#Data Cleaning

import pandas as pd

patients_data = {
    'patient_id': [1, 2, 3, 4, 5, 6],
    'patient_name': ['John Smith', 'Emily Johnson', 'Michael Brown', 'Sarah Davis', 'James Wilson', 'Jane Doe'],
    'date_of_birth': ['1980-05-15', '1975-09-22', '1990-02-10', '1988-11-18', '1972-07-30', '1995-03-25'],
    'gender': ['Male', 'Female', 'Male', 'Female', 'Male', 'Female'],
    'phone_number': ['123-456-7890', '456-789-0123', 'NaN', '012-345-6789', '234-567-8901', '345-678-9012'],
    'address': ['123 Main St', '456 Elm St', '789 Oak St', '987 Pine St', '654 Maple St', 'NaN']
}

prescriptions_data = {
    'prescription_id': [1, 2, 3, 4, 5, 6],
    'patient_id': [1, 2, 3, 4, 5, 6],
    'medication': ['Lisinopril', 'NaN', 'Amoxicillin', 'Levothyroxine', 'Simvastatin', 'Metformin'],
    'dosage': ['10mg', '200mg', 'NaN', '50mcg', '20mg', '500mg'],
    'date_prescribed': ['2023-01-05', '2023-01-10', '2023-01-15', 'NaN', '2023-01-25', '2023-01-30'],
    'doctor_name': ['Dr. Alex Lee', 'Dr. Jessica Chen', 'Dr. David Smith', 'Dr. Laura Brown', 'NaN', 'Dr. Michael Wang']
}

# Create DataFrames
patients_df = pd.DataFrame(patients_data)
prescriptions_df = pd.DataFrame(prescriptions_data)

# Display the first few rows of each DataFrame
print("Patients DataFrame:")
print(patients_df.head())
print("\nPrescriptions DataFrame:")
print(prescriptions_df.head())

# Check for missing values
print("\nMissing values in Patients DataFrame:")
print(patients_df.isnull().sum())
print("\nMissing values in Prescriptions DataFrame:")
print(prescriptions_df.isnull().sum())

# Check for duplicates
print("\nDuplicate rows in Patients DataFrame:", patients_df.duplicated().sum())
print("Duplicate rows in Prescriptions DataFrame:", prescriptions_df.duplicated().sum())

# Handling missing values by Filling with empty string
patients_df.fillna('', inplace=True)  
prescriptions_df.fillna('', inplace=True)

# Removing duplicates
patients_df.drop_duplicates(inplace=True)
prescriptions_df.drop_duplicates(inplace=True)


# Save cleaned data to CSV files
patients_df.to_csv('cleaned_patients.csv', index=False)
prescriptions_df.to_csv('cleaned_prescriptions.csv', index=False)
