class FakeAPI {

  static Future<Map<String, dynamic>> getTermsOfService() async {
    await Future.delayed(Duration(seconds: 2));
    return {
      "status": "success",
      "data": {
        "terms": "<h1>Terms of Service</h1><p>These are the terms of service...</p>"
      }
    };
  }
  static Future<String> fetchVehicleCategoryData() async {
    // Dữ liệu JSON giả
    final jsonResponse = '''
    {
      "success": "true",
      "error": null,
      "message": "Data fetched successfully",
      "data": [
        {
          "id": "1",
          "libelle": "Sedan",
          "prix": "20000",
          "image": "https://example.com/sedan.png",
          "selected_image": "https://example.com/sedan_selected.png",
          "status": "available",
          "creer": "2023-01-01",
          "modifier": "2023-02-01",
          "updated_at": "2023-02-01",
          "deleted_at": null,
          "selected_image_path": "/images/sedan_selected.png",
          "statut_commission_perc": "fixed",
          "commission_perc": "5.0",
          "type_perc": "percentage",
          "delivery_charges": "50.0",
          "minimum_delivery_charges": "20.0",
          "minimum_delivery_charges_within": "10.0"
        },
        {
          "id": "2",
          "libelle": "SUV",
          "prix": "30000",
          "image": "https://example.com/suv.png",
          "selected_image": "https://example.com/suv_selected.png",
          "status": "available",
          "creer": "2023-03-01",
          "modifier": "2023-04-01",
          "updated_at": "2023-04-01",
          "deleted_at": null,
          "selected_image_path": "/images/suv_selected.png",
          "statut_commission_perc": "percentage",
          "commission_perc": "7.0",
          "type_perc": "percentage",
          "delivery_charges": "70.0",
          "minimum_delivery_charges": "25.0",
          "minimum_delivery_charges_within": "15.0"
        }
      ]
    }
    ''';
    await Future.delayed(Duration(seconds: 1));
    return jsonResponse;
  }
}
