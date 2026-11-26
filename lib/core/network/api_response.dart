dynamic unwrap(dynamic body) =>
    body is Map && body.containsKey('data') ? body['data'] : body;

List<Map<String, dynamic>> unwrapList(dynamic body) =>
    (unwrap(body) as List? ?? const []).cast<Map<String, dynamic>>();
