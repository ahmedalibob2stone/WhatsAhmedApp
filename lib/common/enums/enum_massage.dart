



enum EnumData{
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  const EnumData(this.type);
  final String type;

}

extension ConverMessage on String {
  EnumData toEnum() {
    switch (this) {
      case 'audio':
        return EnumData.audio;
      case 'image':
        return EnumData.image;
      case 'text':
        return EnumData.text;
      case 'gif':
        return EnumData.gif;
      case 'video':
        return EnumData.video;
      default:
        return EnumData.text;
    }
  }
}