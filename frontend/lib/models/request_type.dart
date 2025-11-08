enum RequestType {
  banquet,
  travel,
  retail;

  String get label {
    return switch (this) {
      RequestType.banquet => 'Banquet & Venue',
      RequestType.travel => 'Travel & Stay',
      RequestType.retail => 'Retail Store',
    };
  }
}

