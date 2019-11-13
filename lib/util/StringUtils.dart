class StringUtils{
  static String stripEmpty(String original){
    return
         original
        .replaceAll("</p> <p>","<br>")
        .replaceAll("，<br>","，")
        .replaceAll("，","，<br>")
        .replaceAll("；","；<br>")
        .replaceAll("？","，<br>")
        .replaceAll("！","，<br>")
        .replaceAll("。&nbsp","。")
        .replaceAll("。&nbsp;","。")
        .replaceAll("。&nbsp ;","。")
        .replaceAll("。 <br/>","。")
        .replaceAll("。 <br>","。")
        .replaceAll("。<br/>","。")
        .replaceAll("。<br>","。")
        .replaceAll("。","。<br>")
        .replaceAll("。<br>;","。<br>")
        .replaceAll("<br> <br>","<br>")
        .replaceAll("<br><br/>","<br>")
        .replaceAll("<br><br>","<br>")
        .replaceAll("<br></span><br/>","<br>")
        .replaceAll("<p>", '<p style="text-align:center">')
    ;
  }
}