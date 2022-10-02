class GestureEntity {
  static GestureEntity bend = GestureEntity(0, "食指弯曲",
      "该手势需从放松状态开始，轻轻握拳，大拇指外扣其他四指，抵住中指并伸出食指，之后食指尖稍稍向内弯曲，保持钩状。", "bend");
  static GestureEntity fist = GestureEntity(
      1,
      "握拳",
      "该手势需从手掌自然放松状态开始，除大拇指外，其他指尖向掌心合拢，再将大拇指向内扣住另外四指，并保持大拇指指尖放在食指第二关节上。",
      "fist");
  static GestureEntity grasp = GestureEntity(
      2, "球状抓握", "该手势从放松状态开始，五指向内稍微弯曲，假象有网球状大小的球类握于手心，保持不动。", "grasp");
  static GestureEntity hook = GestureEntity(
      3,
      "钩状抓握",
      "该手势需以放松状态起始，掌心向内，并弯曲除大拇指以外的其他四指，保持四指指尖与掌心间隔一根手指的距离，大拇指延伸展方向向上翘，努力使指尖指向上方。",
      "hook");
  static GestureEntity palm =
      GestureEntity(4, "手张开", " 该手势需从放松状态起，指尖延手指自然方向用力展开，使五指不粘连、不重合。", "palm");
  static GestureEntity parallel = GestureEntity(5, "并指",
      "该手势需要先以放松状态开始，之后轻轻握拳，以大拇指扣住小拇指，同时食指、中指与无名指向上方展开并保持。", "parallel");
  static GestureEntity point = GestureEntity(
      6,
      "食指伸展",
      "该手势需要从放松状态开始，首先手掌用力向掌心内侧合拢，大拇指握于三指外，并抵住中指指尖的第一指关节，之后用力展开食指向上方伸展并保持。",
      "point");
  static GestureEntity relax = GestureEntity(7, "放松",
      "该手势从放松状态开始，翻转手心朝下，四指以自然状态微微弯曲，并保持合拢状态，大拇指抵住食指前端第一关节。", "relax");
  static List<GestureEntity> gestureList = [
    bend,
    fist,
    grasp,
    hook,
    palm,
    parallel,
    point,
    relax
  ];

  final int id;
  final String nameStr;
  final String description;
  final String name;

  GestureEntity(this.id, this.nameStr, this.description, this.name);

  static GestureEntity getGestureById(int id) {
    return gestureList[id];
  }
}
