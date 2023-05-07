#!/bin/bash

PATIENT_FILE="patients.csv"

# Welcome message
clear
echo -e "\033[32mWelcome to the Patient Management System of Hospital Spence\033[0m"

# Main menu
while true; do
  echo ""
  echo "[L/l]List patients"
  echo "[A/a]Add a new patient"
  echo "[S/s]Search patient"
  echo "[D/d]Delete patient"
  echo "[E/e]Exit"
  read -p "Enter your choice: " choice
  echo ""
case $choice in
    [Ll])
      clear
      echo -e "\033[32mListing patients...\033[0m"
      echo -e "\033[34mPatient ID\tFirst Name\tLast Name\tPhone Number\033[0m"
      echo "------------------------------------------------------------"
      cat $PATIENT_FILE | awk -F ',' '{print toupper($1) "\t" toupper($2) "\t" toupper($3) "\t" $4}' | sed 's/,//g' | sort -k3,2
      ;;
    [Aa])
      clear
      echo -e "\033[32mAdding a new patient...\033[0m"
      read -p "Enter first name: " first_name
      read -p "Enter last name: " last_name
      read -p "Enter phone number: " phone_number
      
  # Generate a new patientId
last_name_prefix=${last_name:0:4}
first_name_prefix=${first_name:0:1}
patient_id=$last_name_prefix$first_name_prefix

if grep -q "^$patient_id," $PATIENT_FILE; then
  counter=1
  while grep -q "^${patient_id}_${counter}," $PATIENT_FILE; do
    ((counter++))
  done
  patient_id="${patient_id}_${counter}"
  echo "Patient ID already exists, new Patient ID generated: ${patient_id}"
fi

# Add the new patient to the patient records
echo "$patient_id,$first_name,$last_name,$phone_number" >> $PATIENT_FILE
echo -e "\033[32mThe new Patient ID is $patient_id\033[0m"
echo -e "\033[32mThe new patient is added to the patient records.\033[0m"

      ;;
    [Ss])
      clear
      echo -e "\033[32mSearching a patient...\033[0m"
      read -p "Enter the last name or a part of it: " last_name
      echo -e "\033[34mHere are the matching records...\033[0m"
      echo "------------------------------------------------------------"
      grep -i "$last_name" $PATIENT_FILE | awk -F ',' '{print toupper($4) "\t" toupper($1) "\t" toupper($2) "\t" $3}' | sed 's/,//g' | sed 's/\b\([a-z]\)/\u\1/g'

      ;;
    [Dd])
      clear
      echo -e "\033[32mDeleting a patient...\033[0m"
      read -p "Enter the last name or a part of it: " last_name
      sed -i "/^.*,$last_name,/I d" $PATIENT_FILE
      echo ""
      echo "All patient records with the last name containing '$last_name' have been deleted."
      ;;
    [Ee])
      clear
      echo -e "\033[32mThanks for using the Patient Management System of Hospital Spence.\033[0m"
      echo ""
      exit 0
      ;;
    *)
echo -e "\033[31mInvalid choice. Please try again.\033[0m"
sleep 2
;;
esac
done


      clear
