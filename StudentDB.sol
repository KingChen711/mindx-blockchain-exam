// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Counters.sol";

contract StudentDB {
    using Counters for Counters.Counter;

    Counters.Counter private _studentIds;
    address public admin;

    mapping(uint256 => Student) private idToStudent;

    constructor() {
        admin = msg.sender;
    }

    struct Student {
        uint256 studentId;
        string name;
        uint256 age;
    }

    function addStudent(
        string memory name,
        uint256 age
    ) public onlyAdmin returns (uint256) {
        require(age >= 0);

        _studentIds.increment();

        uint256 newStudentId = _studentIds.current();

        idToStudent[newStudentId] = Student(newStudentId, name, age);

        return newStudentId;
    }

    function getAllStudents() public view onlyAdmin returns (Student[] memory) {
        uint256 itemCount = _studentIds.current();

        Student[] memory items = new Student[](itemCount);

        for (uint256 i = 0; i < itemCount; i++) {
            uint256 currentId = i + 1;
            Student storage currentItem = idToStudent[currentId];
            items[i] = currentItem;
        }

        return items;
    }

    function getStudentById(
        uint256 studentId
    ) public view onlyAdmin returns (Student memory) {
        require(studentId != 0);

        Student storage foundedStudent = idToStudent[studentId];

        require(foundedStudent.studentId != 0, "Student not found");

        return foundedStudent;
    }

    function updateStudent(
        uint256 studentId,
        string memory name,
        uint256 age
    ) public onlyAdmin {
        require(age >= 0);
        //This statement helps check existing student
        Student memory foundedStudent = getStudentById(studentId);

        idToStudent[foundedStudent.studentId].name = name;
        idToStudent[foundedStudent.studentId].age = age;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only Admin");
        _;
    }
}
