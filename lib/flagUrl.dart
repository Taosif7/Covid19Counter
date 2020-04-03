// Method to get url of flag by name of country (as specified on worldometer.com/coronavirus/)
// We are using www.countries-ofthe-world.com website's url to get flag url automatically
// others which are either not present or have different names have to be handled manually
String getFlagImageUrl(String countryName) {
  // handle different names cases
  if (countryName == "USA") countryName = "United-States-of-America";
  if (countryName == "UK") countryName = "United-Kingdom";
  if (countryName == "UAE") countryName = "United-Arab-Emirates";
  if (countryName == "S.-Korea") countryName = "Korea-South";
  if (countryName == "Czechia") countryName = "Czech-Republic";
  if (countryName == "Bosnia-and-Herzegovina") countryName = "Bosnia-Herzegovina";
  if (countryName == "Réunion") countryName = "France";
  if (countryName == "Ivory-Coast") countryName = "Cote-d-Ivoire";
  if (countryName == "DRC") countryName = "Congo-Democratic-Republic-of";
  if (countryName == "Antigua-and-Barbuda") countryName = "Antigua";
  if (countryName == "CAR") countryName = "Central-African-Republic";
  if (countryName == "Saint-Lucia") countryName = "St-Lucia";
  if (countryName == "Saint-Kitts-and-Nevis") countryName = "St-Kitts-Nevis";
  if (countryName == "St.-Vincent-Grenadines") countryName = "St-Vincent-the-Grenadines";
  if (countryName == "Brunei-") countryName = "Brunei";

  // auto generate country string
  String url =
      "https://www.countries-ofthe-world.com/flags-normal/flag-of-" + countryName.replaceAll(new RegExp(r' '), '-') + ".png";

  // handle not present name cases
  if (countryName == "Diamond-Princess-")
    url = "https://www.cruiseindustrynews.com/images/stories/wire/2020/feb/princess-cruises-vector-logo.png";
  if (countryName == "Hong-Kong")
    url = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Flag_of_Hong_Kong.svg/1200px-Flag_of_Hong_Kong.svg.png";
  if (countryName == "Faeroe-Islands")
    url =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Flag_of_the_Faroe_Islands.svg/234px-Flag_of_the_Faroe_Islands.svg.png";
  if (countryName == "Martinique")
    url =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Snake_Flag_of_Martinique.svg/220px-Snake_Flag_of_Martinique.svg.png";
  if (countryName == "Channel-Islands") url = "https://upload.wikimedia.org/wikipedia/commons/2/20/Jersey_flag_300.png";
  if (countryName == "Guadeloupe") url = "https://www.graphicmaps.com/r/w1047/images/flags/gp-flag.jpg";
  if (countryName == "Gibraltar") url = "https://www.graphicmaps.com/r/w1047/images/flags/gp-flag.jpg";
  if (countryName == "Mayotte")
    url =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Flag_of_Mayotte_%28local%29.svg/1200px-Flag_of_Mayotte_%28local%29.svg.png";
  if (countryName == "Macao")
    url = "https://upload.wikimedia.org/wikipedia/commons/thumb/6/63/Flag_of_Macau.svg/383px-Flag_of_Macau.svg.png";
  if (countryName == "Aruba") url = "https://upload.wikimedia.org/wikipedia/commons/d/d4/Flag_of_Aruba.png";
  if (countryName == "French-Polynesia")
    url =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/d/db/Flag_of_French_Polynesia.svg/1200px-Flag_of_French_Polynesia.svg.png";
  if (countryName == "Isle-of-Man")
    url =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Flag_of_the_Isle_of_Man.svg/1280px-Flag_of_the_Isle_of_Man.svg.png";
  if (countryName == "French-Guiana")
    url =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Flag_of_French_Guiana.svg/1280px-Flag_of_French_Guiana.svg.png";
  if (countryName == "Bermuda")
    url = "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/Flag_of_Bermuda.svg/1280px-Flag_of_Bermuda.svg.png";
  if (countryName == "New-Caledonia")
    url =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/New_Caledonia_flags_merged_%282017%29.svg/1200px-New_Caledonia_flags_merged_%282017%29.svg.png";
  if (countryName == "Saint-Martin") url = "https://upload.wikimedia.org/wikipedia/commons/8/8a/Flag_of_Saint_Martin.png";
  if (countryName == "Greenland")
    url = "https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/Flag_of_Greenland.svg/1280px-Flag_of_Greenland.svg.png";
  if (countryName == "Curaçao") url = "https://cdn.freebiesupply.com/logos/large/2x/curacao-logo-png-transparent.png";
  if (countryName == "Montserrat")
    url = "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Flag_of_Montserrat.svg/250px-Flag_of_Montserrat.svg.png";
  if (countryName == "St.-Barth") url = "https://upload.wikimedia.org/wikipedia/commons/b/b8/Flag_of_Saint_Barthelemy.PNG";
  if (countryName == "Sint-Maarten")
    url =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Flag_of_Sint_Maarten.svg/1280px-Flag_of_Sint_Maarten.svg.png";
  if (countryName == "MS-Zaandam" || countryName == "MS-Zaandam-")
    url = "https://s2.reutersmedia.net/resources/r/?m=02&d=20200328&t=2&i=1509143554&r=LYNXMPEG2Q21C&w=600";
  if (countryName == "Anguilla")
    url = "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Flag_of_Anguilla.svg/1280px-Flag_of_Anguilla.svg.png";
  if (countryName == "Cayman-Islands")
    url =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Flag_of_the_Cayman_Islands.svg/1024px-Flag_of_the_Cayman_Islands.svg.png";
  if (countryName == "British-Virgin-Islands")
    url =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Flag_of_the_British_Virgin_Islands.svg/320px-Flag_of_the_British_Virgin_Islands.svg.png";
  if (countryName == "U.S.-Virgin-Islands")
    url =
    "https://www.worldatlas.com/webimage/flags/countrys/zzzflags/vilarge.gif";
  if (countryName == "Turks-and-Caicos")
    url =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Flag_of_the_Turks_and_Caicos_Islands_%283-2%29.svg/1200px-Flag_of_the_Turks_and_Caicos_Islands_%283-2%29.svg.png";
  if (countryName == "Puerto-Rico") url = "https://pluspng.com/img-png/puerto-rico-png-file-flag-of-puerto-rico-png-1200.png";
  if (countryName == "Guam") url = "https://upload.wikimedia.org/wikipedia/commons/a/af/Guam_flag_300.png";
  if (countryName == "Caribbean-Netherlands") url =
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Flag_of_the_Netherlands.svg/225px-Flag_of_the_Netherlands.svg.png";
  if (countryName == "All") url = "https://www.gstatic.com/earth/social/00_generic_facebook-001.jpg";

  return url;
}
