class Validators {
  static Function(String) phoneNumberValidator = (String value) {
    RegExp phoneRegex = RegExp(r"^(\+\d{1,3}[- ]?)?\d{10}$");
    if (!phoneRegex.hasMatch(value) || value.isEmpty) {
      return "Enter valid phone number";
    }
    return null;
  };
  static Function(String) emailValidator = (String value) {
    RegExp phoneRegex = RegExp(r"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$");
    if (!phoneRegex.hasMatch(value) || value.isEmpty) {
      return "Enter valid Email Address";
    }
    return null;
  };

  static Function(String) nameValidator = (String value) {
    if (value.isEmpty) {
      return "Name cant'be empty";
    }
    return null;
  };

  static Function(String) rentValidator = (String value) {
    if (value.isEmpty) {
      return "Amount cant'be empty";
    }
    return null;
  };

  static Function(String) joinedDateValidator = (String value) {
    if (value.isEmpty) {
      return "Joined Date cant'be empty";
    }
    return null;
  };

  static Function(String) dateDateValidator = (String value) {
    if (value.isEmpty) {
      return "Date cant'be empty";
    }
    return null;
  };
}
