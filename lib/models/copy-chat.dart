class Chat {
  final String id;
  final String name;
  final String message;
  final String time;
  final String unreadCount;
  final String profilePicture;
  final int avatarColor;
  final bool isVerified;
  final bool hasPhoto;
  final String? mediaType;  // Tambahkan properti untuk tipe media
  final String? mediaUrl;   // Tambahkan properti untuk URL media

  Chat({
    required this.id,
    required this.name,
    required this.message,
    required this.time,
    this.unreadCount = '',
    required this.profilePicture,
    required this.avatarColor,
    this.isVerified = false,
    this.hasPhoto = false,
    this.mediaType,          // Parameter opsional untuk tipe media
    this.mediaUrl,           // Parameter opsional untuk URL media
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      unreadCount: json['unread_count']?.toString() ?? '',
      profilePicture: json['profile_picture']?.toString() ?? '',
      avatarColor: json['avatar_color'] is String 
          ? int.parse(json['avatar_color'] ?? '0xFF1E88E5')
          : (json['avatar_color'] as int?) ?? 0xFF1E88E5,
      isVerified: (json['is_verified'] is int)
          ? json['is_verified'] == 1
          : json['is_verified'] as bool? ?? false,
      hasPhoto: (json['has_photo'] is int)
          ? json['has_photo'] == 1
          : json['has_photo'] as bool? ?? false,
      mediaType: json['media_type']?.toString(),    // Tambahkan parsing untuk tipe media
      mediaUrl: json['media_url']?.toString(),      // Tambahkan parsing untuk URL media
    );
  }
}