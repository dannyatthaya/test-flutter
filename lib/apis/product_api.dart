import 'package:dio/dio.dart';
import 'package:mini_project_flutter/main.dart';
import 'package:mini_project_flutter/models/dio/index_params_model.dart';
import 'package:mini_project_flutter/models/dio/index_response_model.dart';
import 'package:mini_project_flutter/models/product_model.dart';
import 'package:mini_project_flutter/models/dio/response_model.dart';
import 'package:mini_project_flutter/models/dio/show_params.model.dart';
import 'package:mini_project_flutter/utils/snackbar_util.dart';

class ProductAPI {
  static final dio = Dio(
    BaseOptions(
      baseUrl: apiUrl ?? '',
      contentType: 'application/json',
      headers: {
        'credentials': false,
      },
    ),
  );

  static final apiUrl = sharedPreferences.getString('API_URL');

  static Future<IndexResponseModel<List<ProductModel>>> index(
      {IndexParamsModel? params}) async {
    List<ProductModel> data = [];
    ResponseModel? res;

    try {
      final response = await dio.get(
        '/api/products',
        queryParameters: params?.toJson(),
      );

      if (response.statusCode == 200) {
        res = ResponseModel.fromJson(response.data);

        data = List.from(res.data)
            .map((resData) => ProductModel.fromJson(resData))
            .toList();
      }

      return IndexResponseModel(
        data: data,
        pagination: res!.meta!,
      );
    } catch (error) {
      showErrorSnackbar(error.toString());

      rethrow;
    }
  }

  static Future<ProductModel?> show({required ShowParamsModel params}) async {
    ProductModel? data;

    try {
      final response = await dio.get('/api/products/${params.id}');

      if (response.statusCode == 200) {
        ResponseModel res = ResponseModel.fromJson(response.data);

        if (res.data != null) {
          data = ProductModel.fromJson(res.data);
        }
      }

      return data;
    } catch (error) {
      showErrorSnackbar(error.toString());

      rethrow;
    }
  }

  static Future<void> store(ProductModel params) async {
    try {
      await dio.post('/api/products', data: params.toRequest());
    } catch (error) {
      showErrorSnackbar(error.toString());
      rethrow;
    }
  }

  static Future<void> update(ProductModel params) async {
    try {
      await dio.put('/api/products/${params.id}', data: params.toRequest());
    } catch (error) {
      showErrorSnackbar(error.toString());
      rethrow;
    }
  }

  static Future<void> destroy({required ShowParamsModel params}) async {
    try {
      await dio.delete('/api/products/${params.id}');
    } catch (error) {
      showErrorSnackbar(error.toString());
      rethrow;
    }
  }
}
