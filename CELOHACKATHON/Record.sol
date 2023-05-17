// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Pharmacy.sol";
contract Record {
    
    struct Patients{
        string id;
        string name;
        string phone;
        string gender;
        string height;
        string weight;
        string dob;
        string houseaddr;
        string bloodgroup;
         string medicalconditions;
        string medication;
       
    }
    struct Patientslocation{
         address addr;
        uint date;
        uint longitude;
        uint latitude;
    }


    struct Doctors{
        string id;
        string name;
        string phone;
        string gender;
        string dob;
        string qualification;
        string major;
       string emergencyContact;
        bool isCertified;
        uint date;
    }
    struct Doctorslocation{
         address addr;
        uint longitude;
        uint latitude;
        uint date;
    }
struct PharmaceuticalStores{
        string id;
        string name;
        string phone;
         string gender;
        string dob;
        string pharmacy;
        string  qualification;
        bool isCertified;
    
    
    }
    struct PharmaceuticalStoresLocation{
         address addr;
        uint date;
        uint longitude;
        uint latitude;
    }
   

    struct Appointments{
        address doctoraddr;
        address patientaddr;
        string date;
        string time;
        string prescription;
        string description;
        string diagnosis;
        string status;
        uint creationDate;
    }
    /* ,*/



    
    address public owner;
    address[] public patientList;
    address[] public patientLocation;
    address[] public doctorList;
    address[] public doctorLocation;
    address[] public storeList;
    address[] public storeLocation;
    address[] public appointmentList;
    

    mapping(address => Patients) patients;
    mapping(address => Appointments) appointment;
    mapping(address => Patientslocation) plocation;
    mapping(address => Doctors) doctors;
    mapping(address =>Doctorslocation) dlocation;
    mapping(address => PharmaceuticalStores) stores;
    mapping(address =>PharmaceuticalStoresLocation) storelocation;
    mapping(address=>mapping(address=>bool)) isApproved;
    mapping(address => bool) isPatient;
    mapping(address => bool) isDoctor;
    mapping(address => bool) isPharmaceuticalStores;
    mapping(address => uint) AppointmentPerPatient;


    uint256 public patientCount = 0;
    uint256 public doctorCount = 0;
    uint256 public storeCount = 0;
    uint256 public appointmentCount = 0;
    uint256 public permissionGrantedCount = 0;
    
    function Data() public {
        owner = msg.sender;
    }
    
    //Retrieve patients details from user sign up page and store the details into the blockchain
    function setPatients(string memory _id, string memory _name, string memory _phone, string memory _gender, string memory _dob, string memory _height, string memory _weight, string memory _houseaddr, string memory _bloodgroup, string memory _medicalconditions, string memory _medication) public {
        require(!isPatient[msg.sender]);
        Patients storage p = patients[msg.sender];
        
        p.id = _id;
        p.name = _name;
        p.phone = _phone;
        p.gender = _gender;
        p.dob = _dob;
        p.height = _height; 
        p.weight = _weight;
        p.houseaddr = _houseaddr;
        p.bloodgroup = _bloodgroup;
        p.medicalconditions = _medicalconditions;
        p.medication = _medication; 
        
        patientList.push(msg.sender);
        isPatient[msg.sender] = true;
        isApproved[msg.sender][msg.sender] = true;
        patientCount++;
    }
    
    //Allows patient to edit their existing record
    function editPatients(string memory _id, string memory _name, string memory _phone, string memory _gender, string memory _dob, string memory _height, string memory _weight, string memory _houseaddr, string memory _bloodgroup, string memory _medicalconditions, string memory _medication) public {
        require(isPatient[msg.sender]);
        Patients storage p = patients[msg.sender];
        
        p.id = _id;
        p.name = _name;
        p.phone = _phone;
        p.gender = _gender;
        p.dob = _dob;
        p.height = _height; 
        p.weight = _weight;
        p.houseaddr = _houseaddr;
        p.bloodgroup = _bloodgroup;
        p.medicalconditions = _medicalconditions;
        p.medication = _medication;  
    }
 //Set patients location information
function setPatientsLocation( uint _latitude, uint _longitude) public {
    require(isPatient[msg.sender]);
    Patientslocation storage location = plocation[msg.sender];
        
    location.addr = msg.sender;
    location.date = block.timestamp;
    location.latitude = _latitude;
    location.longitude = _longitude;    
}
//function to get the location of the patients
function getPatientLocation() public view returns (Patientslocation memory) {
    require(isPatient[msg.sender]);
    return (plocation[msg.sender]);
}



    //Retrieve Doctor details from users sign up page and store the details into the blockchain
    function setDoctor(string memory _id, string memory _name, string memory _phone, string memory _gender, string memory _dob, string memory _qualification, string memory _major, bool _isCertified) public {
        require(!isDoctor[msg.sender]);
        require(bytes(_major).length > 0, "Specialty cannot be empty");
  
      Doctors storage d = doctors[msg.sender];
        
        d.id = _id;
        d.name = _name;
        d.phone = _phone;
        d.gender = _gender;
        d.dob = _dob;
        d.qualification = _qualification;
        d.major = _major;
        d.isCertified = _isCertified;
        d.emergencyContact;
          
        
        doctorList.push(msg.sender);
        isDoctor[msg.sender] = true;
        doctorCount++;
    }
    //Allows doctors to edit their existing profile
    function editDoctor(string memory _id, string memory _name, string memory _phone, string memory _gender, string memory _dob, string memory _qualification, string memory _major,bool _isCertified) public {
        require(isDoctor[msg.sender]);
        Doctors storage d = doctors[msg.sender];
        
        d.id = _id;
        d.name = _name;
        d.phone = _phone;
        d.gender = _gender;
        d.dob = _dob;
        d.qualification = _qualification;
        d.major = _major;
        d.isCertified = _isCertified;
        d.emergencyContact;
        
       
    }

function setDoctorlocation(uint _latitude, uint _longitude) public {
        require(!isDoctor[msg.sender]);
      Doctorslocation storage location = dlocation[msg.sender];

        location.addr = msg.sender;
        location.date = block.timestamp;
        location.latitude = _latitude;
        location.longitude = _longitude;
        }
function getDoctorslocation()public view returns(Doctorslocation memory){
      require(isDoctor[msg.sender]);
    return (dlocation[msg.sender]);
}

    //Retrieve appointment details from appointment page and store the details into the blockchain
    function setAppointment(address _addr, string memory _date, string memory _time, string memory _diagnosis, string memory _prescription, string memory _description, string memory _status) public {
        require (isDoctor[msg.sender]);
        Appointments storage a = appointment[_addr];
        
        a.doctoraddr = msg.sender;
        a.patientaddr = _addr;
        a.date = _date;
        a.time = _time;
        a.diagnosis = _diagnosis;
        a.prescription = _prescription; 
        a.description = _description;
        a.status = _status;
        a.creationDate = block.timestamp;
        appointmentList.push(_addr);
        appointmentCount++;
        AppointmentPerPatient[_addr]++;
    }
    
    //Retrieve appointment details from appointment page and store the details into the blockchain
    function updateAppointment(address _addr, string memory _date, string memory _time, string memory _diagnosis, string memory _prescription, string memory _description, string memory _status) public {
        require(isDoctor[msg.sender]);
        Appointments storage a = appointment[msg.sender];
        
        a.doctoraddr = msg.sender;
        a.patientaddr = _addr;
        a.date = _date;
        a.time = _time;
        a.diagnosis = _diagnosis;
        a.prescription = _prescription; 
        a.description = _description;
        a.status = _status;
    }


    //Retrieve PharmaciticalStores details from registration page and store the details into the blockchain
    function setPharmaciticalStore(string  memory _id, string memory _name, string memory _phone, string memory _gender, string memory _dob, string memory _qualification, bool _isCertified) public {
        require(!isPharmaceuticalStores[msg.sender]);
        PharmaceuticalStores storage d = stores [msg.sender];
        
        d.id = _id;
        d.name = _name;
        d.phone = _phone;
        d.gender = _gender;
        d.dob = _dob;
        d.qualification = _qualification;

       d.isCertified = _isCertified;
    
        
        doctorList.push(msg.sender);
        isDoctor[msg.sender] = true;
        doctorCount++;
    }
    //Allows PharmaciticalStores to edit their existing profile
    function editPharmaceuticalStores(string memory _id, string memory _name, string memory _phone, string memory _gender, string memory _dob, string memory _qualification, bool _isCertified) public {
        require(isPharmaceuticalStores[msg.sender]);
        PharmaceuticalStores storage d = stores[msg.sender];
        
        d.id = _id;
        d.name = _name;
        d.phone = _phone;
        d.gender = _gender;
        d.dob = _dob;
        d.qualification = _qualification;
        d.isCertified = _isCertified;
        
    }

function setPharmaceuticalStoreLocation( uint _latitude, uint _longitude) public {
        require(!isPharmaceuticalStores[msg.sender]);
        PharmaceuticalStoresLocation storage d = storelocation[msg.sender];

        d.addr = msg.sender;
        d.date = block.timestamp;
        d.latitude = _latitude;
        d.longitude = _longitude;
}
function getPharmaceuticalStoreLocation()public view returns(PharmaceuticalStoresLocation memory){
      require(!isPharmaceuticalStores[msg.sender]);
    return (storelocation[msg.sender]);
}




    
    //Owner of the record must give permission to doctor before they are allowed to view records
    function givePermission(address _address) public returns(bool success) {
        isApproved[msg.sender][_address] = true;
        permissionGrantedCount++;
        return true;
    }

    //Owner of the record can take away the permission granted to doctors to view records
    function RevokePermission(address _address) public returns(bool success) {
        isApproved[msg.sender][_address] = false;
        return true;
    }

    //Retrieve a list of all patients address
    function getPatients() public view returns(address[] memory) {
        return patientList;
    }
    //Retrieve a list of all doctors address
    function getDoctors() public view returns(address[]  memory) {
        return doctorList;
    }
     //Retrieve a list of all PharmaciticalStores address
    function getPharmaciticalStores () public view returns(address[] memory) {
        return storeList;
    }
    //Retrieve a list of all appointments address
    function getAppointments() public view returns(address[] memory) {
        return appointmentList;
    }
    
    
    //Search patient record creation date by entering a patient address
    function searchRecordDate() public view returns(uint) {
       
        Patientslocation storage location = plocation[msg.sender];

        return (location.date);
    }
    //Search doctor profile creation date by entering a patient address
    function searchDoctorDate(address _address) public view returns(uint) {
        Doctors storage d = doctors[_address];
        
        return (d.date);
    }
    //Search appointment creation date by entering a patient address
    function searchAppointmentDate(address _address) public view returns(uint) {
        Appointments storage a = appointment[_address];
        
        return (a.creationDate);
    }
    //Retrieve patient count
    function getPatientCount() public view returns(uint256) {
        return patientCount;
    }
    //Retrieve doctor count
    function getDoctorCount() public view returns(uint256) {
        return doctorCount;
    }
    //Retrieve appointment count
    function getAppointmentCount() public view returns(uint256) {
        return appointmentCount;
    }
    //Retrieve permission granted count
    function getPermissionGrantedCount() public view returns(uint256) {
        return permissionGrantedCount;
    }
    //Retrieve permission granted count
    function getAppointmentPerPatient(address _address) public view returns(uint256) {
        return AppointmentPerPatient[_address];
    }



    //Search patient details by entering a patient address (Only record owner or doctor with permission will be allowed access)
    function searchPatientDemographic(address _address) public view returns(Patients memory,Patientslocation memory) {
        require(isApproved[_address][msg.sender]);
        
        return (patients[_address],plocation[_address]);
    }
    //Search patient details by entering a patient address (Only record owner or doctor with permission will be allowed access)
    function searchPatientMedical(address _address) public view returns(Patients memory,Patientslocation memory) {
        require(isApproved[_address][msg.sender]);
        

        return (patients[_address],plocation[_address]);
    }
    //Search doctor details by entering a doctor address (Only doctor will be allowed access)
    function searchDoctor(address _address) public view returns(Doctors memory) {
        require(isDoctor[_address]);
        
        return (doctors[_address]);
    }
    
    //Search appointment details by entering a patient address
    function searchAppointment(address _address) public view returns(Appointments memory,Doctors memory) {
        Appointments storage a = appointment[_address];
        return (appointment[_address], doctors[a.doctoraddr]);
    }
}