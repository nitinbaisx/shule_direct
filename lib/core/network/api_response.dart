class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? totalCount;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.totalCount,
  });

  factory ApiResponse.success({
    T? data,
    String? message,
    int? totalCount,
  }) {
    return ApiResponse(
      success: true,
      message: message,
      data: data,
      totalCount: totalCount,
    );
  }

  factory ApiResponse.failure({String? message}) {
    return ApiResponse(success: false, message: message);
  }
}
