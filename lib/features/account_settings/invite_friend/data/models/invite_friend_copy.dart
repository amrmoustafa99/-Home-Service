class InviteFriendCopy {
  InviteFriendCopy._();

  static const String screenTitle = 'دعوة الأصدقاء';
  static const String heading = 'ادعُ أصدقاءك';
  static const String subtitleInfo = 'شارك كود دعوتك مع أصدقائك';
  static const String subtitlePrefix = 'ليحصلوا على ';
  static const String subtitleHighlight = 'خصم';
  static const String subtitleSuffix = ' على أول طلب لهم.';
  static const String codeLabel = 'كود دعوتك';
  static const String inviteCode = 'AYK20FRIEND';
  static const String shareButton = 'مشاركة الكود';
  static const String howItWorksTitle = 'كيف تعمل الدعوة؟';
  static const String copiedFeedback = 'تم نسخ الكود';

  static const List<({String title, String subtitle})> steps = [
    (
      title: 'شارك كود دعوتك',
      subtitle: 'أرسله لأصدقائك عبر أي وسيلة تفضلها.',
    ),
    (
      title: 'صديقك ينشئ حسابًا',
      subtitle: 'ويستخدم كود دعوتك عند أول طلب له.',
    ),
    (
      title: 'صديقك يحصل على الخصم',
      subtitle: 'يحصل على 20% خصم على أول طلب له.',
    ),
    (
      title: 'احصل على خصومات',
      subtitle: 'يتم تفعيل خصومات عند دعوة 3 أصدقاء فأكثر.',
    ),
  ];

  static const String footerNote =
      'الكود صالح لجميع المستخدمين الجدد\nلفترة محدودة.';
}