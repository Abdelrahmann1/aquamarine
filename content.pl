#!/usr/bin/perl
# ============================================================
#  AQUA MARINE WATER SYSTEMS — bilingual content
#  Every string is a pair: [ Arabic, English ]
#  Edit here, then run:  perl build.pl
# ============================================================
use strict;
use warnings;
use utf8;

our (%C, @SERVICES, @PROJECTS, @WORKS, @GALLERY, @FULLSERVICES,
     %T, %CATNAME, @NAV, @PROCESS, @LOCATIONS);

# ------------------------------------------------------------
#  Company
# ------------------------------------------------------------
%C = (
  name    => ['أكوا مارين ووتر سيستمز', 'Aqua Marine Water Systems'],
  full    => ['شركة أكوا مارين ووتر سيستمز', 'Aqua Marine Water Systems'],
  addr    => ['2 شارع العطار، بهتيم، شبرا الخيمة، القليوبية',
              '2 El Attar St., Bahtim, Shubra El Kheima, Qalyubia'],
  mobile  => '01006637481',
  mobile2 => '01005551386',
  intl    => '201006637481',
  land    => '202-42220220',
  wa      => '201006637481',
  email   => 'info' . '@' . 'aquamarine-ws.com',
  fb      => 'https://www.facebook.com/aquamarinewatersystem',
  ig      => 'https://www.instagram.com/',
  tw      => 'https://twitter.com/AquaMar48551844/status/1475483948558032901',
  yt      => 'https://www.youtube.com/watch?v=SmqweM1r7A0',
  li      => 'https://www.linkedin.com',
  ytid    => 'SmqweM1r7A0',
  map     => 'https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d215.66515326588038!2d31.279779304389386!3d30.133043084067662!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x3a82f39a060ab2ab!2sHyper%20Ferjany!5e0!3m2!1sen!2seg!4v1653566862459!5m2!1sen!2seg',
);

# ------------------------------------------------------------
#  Services
# ------------------------------------------------------------
@SERVICES = (
  { slug=>'pool-design', img=>'aquamarine16(1).jpg',
    t=>['تصميم حمامات السباحة والنوافير','Swimming Pool & Fountain Design'],
    d=>['تصميم كامل وعمل الحسابات الخاصة بمعدات وشبكات حمامات السباحة وتقديم الرسومات الخاصة بها.',
        'Complete design and engineering calculations for pool equipment and pipework, issued with full drawings.'] },
  { slug=>'pool-build', img=>'aquamarine26(1).jpg',
    t=>['إنشاء وتشطيب وعزل حمامات السباحة','Pool Construction, Finishing & Waterproofing'],
    d=>['أعمال مدنية وتشطيبات وعزل متكامل، مع توريد وتركيب معدات ومستلزمات حمامات السباحة والجاكوزي والهيدروبول.',
        'Civil works, finishes and full waterproofing, with supply and installation of pool, jacuzzi and hydropool equipment.'] },
  { slug=>'fountains', img=>'aquamarine1(1).jpeg',
    t=>['توريد وتركيب النوافير والشلالات','Fountains & Waterfalls'],
    d=>['تنفيذ النوافير والشلالات المائية بجميع أشكالها وأعمال الإضاءة واللاندسكيب المصاحبة لها.',
        'Fountains and water features of every form, with the lighting and landscape works that go with them.'] },
  { slug=>'water-treatment', img=>'aquamarine2(1).jpg',
    t=>['محطات تنقية مياه الشرب وتحلية مياه البحر','Drinking Water & Desalination Plants'],
    d=>['توريد وتركيب محطات تنقية مياه الشرب وتحلية مياه البحر، وتصنيع فلاتر وتنكات المياه بجميع أنواعها.',
        'Supply and installation of drinking-water treatment and seawater desalination plants, with filters and tanks manufactured in-house.'] },
  { slug=>'sewage', img=>'aquamarine3(1).jpg',
    t=>['محطات معالجة مياه الصرف','Wastewater Treatment Plants'],
    d=>['توريد وتركيب محطات معالجة مياه الصرف، وتفريغ وشحن الوسط الترشيحي للفلاتر.',
        'Supply and installation of wastewater treatment plants, including emptying and recharging of filter media.'] },
  { slug=>'pumps', img=>'aquamarine28(1).jpg',
    t=>['طلمبات الرفع بجميع أنواعها','Lifting Pumps'],
    d=>['توريد وتركيب طلمبات الرفع بجميع أنواعها وأعمال الصيانة الدورية اللازمة لها.',
        'Supply and installation of lifting pumps of every type, with the scheduled maintenance they require.'] },
  { slug=>'steam-rooms', img=>'20080707319.jpg',
    t=>['توريد وتركيب غرف البخار','Steam Rooms'],
    d=>['توريد وتركيب غرف البخار للفنادق والقرى السياحية والنوادي الصحية والفلل الخاصة.',
        'Steam rooms supplied and installed for hotels, resorts, health clubs and private villas.'] },
  { slug=>'sauna-rooms', img=>'20070425(009)(2).jpg',
    t=>['توريد وتركيب غرف السونا','Sauna Rooms'],
    d=>['توريد وتركيب غرف السونا بمواصفات الفنادق والنوادي الصحية ووحدات الإقامة الخاصة.',
        'Sauna rooms built to hotel and health-club specification, and for private residences.'] },
  { slug=>'water-networks', img=>'aquamarine22(1).jpg',
    t=>['الأعمال الخاصة بشبكات المياه','Water Networks'],
    d=>['تنفيذ شبكات المياه بكافة أنواعها من ري وصرف وتغذية وحريق، خارجية وداخلية، تأسيس وتشطيب.',
        'Water networks of every kind — irrigation, drainage, supply and firefighting; external and internal, first fix to finish.'] },
);

# ------------------------------------------------------------
#  Projects
# ------------------------------------------------------------
@PROJECTS = (
  { slug=>'porto-sokhna', tag=>'RESORT', img=>'aquamarine25(1).jpg',
    t=>['بورتو السخنة','Porto Sokhna'],
    d=>['مشروع الأبراج لشركة عامر جروب: 3 حمامات سباحة بالمرحلة الأولى و9 حمامات بالمرحلة الثانية، إلى جانب الأعمال الكهروميكانيكية لمنطقة البانوراما ونوافير المدينة العتيقة بالأسكاي مول.',
        "Amer Group's Towers project: three pools in phase one and nine in phase two, alongside the electromechanical works for the Panorama area and the Old Town fountains at Sky Mall."] },
  { slug=>'alf-leila-sharm', tag=>'HOTEL', img=>'aquamarine10(1).jpg',
    t=>['فندق ألف ليلة وليلة — شرم الشيخ','Alf Leila Wa Leila Hotel — Sharm El Sheikh'],
    d=>['تنفيذ جميع الأعمال المائية الموجودة بالفندق من شلالات ونوافير.',
        'All water features across the hotel, from waterfalls to fountains.'] },
  { slug=>'continental-hurghada', tag=>'HOTEL', img=>'aquamarine23(1).jpg',
    t=>['كونتننتال الغردقة','Continental Hurghada'],
    d=>['أعمال حمامات السباحة والمعدات الكهروميكانيكية وشبكات المياه بالمنشأة الفندقية.',
        'Swimming pool works, electromechanical equipment and water networks throughout the hotel.'] },
  { slug=>'cairo-modern-school', tag=>'SCHOOL', img=>'aquamarine5(1).jpg',
    t=>['مدرسة القاهرة الإنجليزية الحديثة','Cairo Modern English School'],
    d=>['حمام سباحة أوليمبي بفرع ميراج سيتي، وأعمال تعديلات غرفة المعدات بفرع مصر الجديدة.',
        'An Olympic pool at the Mirage City campus, plus plant-room modifications at the Heliopolis campus.'] },
  { slug=>'villa-marina', tag=>'VILLA', img=>'aquamarine29(1).jpg',
    t=>['فيلا خاصة — مارينا','Private Villa — Marina'],
    d=>['حمام سباحة متكامل بأعماله المدنية والكهروميكانيكية ضمن أعمال الفلل الخاصة بالساحل الشمالي.',
        'A complete pool with its civil and electromechanical works, part of our private villa portfolio on the North Coast.'] },
  { slug=>'sokhna-sugar-factory', tag=>'INDUSTRIAL', img=>'eeee.jpg',
    t=>['مصنع السكر — السخنة','Sokhna Sugar Factory'],
    d=>['أعمال معالجة المياه وشبكات التغذية والصرف الصناعية بالمصنع.',
        'Water treatment works and industrial supply and drainage networks.'] },
);

# ------------------------------------------------------------
#  Previous works ledger
# ------------------------------------------------------------
%CATNAME = (
  pools => ['حمامات سباحة ونوافير','Pools & Fountains'],
  intl  => ['أعمال خارج مصر','International'],
  san   => ['صحي وشبكات','Plumbing & Networks'],
);

@WORKS = (
 { c=>'pools', t=>['مديرية التربية والتعليم بالمنيا','Minya Directorate of Education'],
   d=>[['إنشاء الحمام وتوريد جميع معداته','Pool construction and supply of all its equipment']] },
 { c=>'pools', t=>['مركز شباب ناصر','Nasser Youth Centre'],
   d=>[['إنشاء وتركيب حمام سباحة (أوليمبي)','Construction and installation of an Olympic pool']] },
 { c=>'pools', t=>['سيراميكا كليوباترا','Ceramica Cleopatra'],
   d=>[['حمام سباحة خاص برئيس مجلس الإدارة — الساحل الشمالي والمقطم','Private pool for the chairman — North Coast and Mokattam']] },
 { c=>'pools', t=>['نادي مدينة 6 أكتوبر','6th of October City Club'],
   d=>[['حمام السباحة بالإضافة إلى مغطس','Swimming pool plus plunge pool'],
       ['إحلال وتجديد الأعمال الميكانيكية والمدنية','Replacement and renewal of the mechanical and civil works']] },
 { c=>'pools', t=>['مدرسة القاهرة الإنجليزية الحديثة — ميراج سيتي','Cairo Modern English School — Mirage City'],
   d=>[['حمام سباحة أوليمبي','Olympic swimming pool']] },
 { c=>'pools', t=>['فندق أوشن باي كلوب — شرم الشيخ','Ocean Bay Club Hotel — Sharm El Sheikh'],
   d=>[['حمام السباحة الرئيسي — أعمال التسخين','Main pool — heating works']] },
 { c=>'pools', t=>['مشروع حياة ريجنسي — شرم الشيخ','Hyatt Regency — Sharm El Sheikh'],
   d=>[['حمامات سباحة ونوافير وشلالات مائية','Swimming pools, fountains and waterfalls'],
       ['تركيب وتشغيل','Installation and commissioning']] },
 { c=>'pools', t=>['فندق نبق — شرم الشيخ','Nabq Hotel — Sharm El Sheikh'],
   d=>[['حمام السباحة الرئيسي','Main swimming pool']] },
 { c=>'pools', t=>['المدرسة الأمريكية الدولية — التجمع الخامس','American International School — Fifth Settlement'],
   d=>[['حمام سباحة (نصف أوليمبي) بجوار أكاديمية الشرطة','Semi-Olympic pool, adjacent to the Police Academy']] },
 { c=>'pools', t=>['قرية غناظة (أربيان بيتش) — شرم الشيخ','Ghazala Resort (Arabian Beach) — Sharm El Sheikh'],
   d=>[['شركة صن رايز للاستثمار السياحي','For Sunrise Tourism Investment'],
       ['عدد 5 حمامات سباحة','5 swimming pools'],
       ['عدد 9 نوافير','9 fountains'],
       ['عدد 3 شلالات','3 waterfalls'],
       ['شبكات المياه: ري وحريق ومياه ساخنة وباردة وتشطيب الصحي الداخلي','Water networks: irrigation, firefighting, hot and cold water, and internal plumbing finishes']] },
 { c=>'pools', t=>['قرية شارمينج هيلز (مونت ميري) — شرم الشيخ','Charming Hills Resort (Monte Mary) — Sharm El Sheikh'],
   d=>[['عدد 3 حمامات سباحة','3 swimming pools'],
       ['عدد 4 نوافير','4 fountains'],
       ['نوافير وشلالات حمام السباحة لبحيرة الشيزلونجات','Pool fountains and waterfalls for the sun-lounger lagoon'],
       ['شبكات المياه: ري وحريق ومياه ساخنة وباردة وتشطيب صحي','Water networks: irrigation, firefighting, hot and cold water, and plumbing finishes']] },
 { c=>'pools', t=>['قرية الربيع — شرم الشيخ','El Rabie Resort — Sharm El Sheikh'],
   d=>[['نافورة اللاندسكيب','Landscape fountain'],
       ['نافورة مدخل القرية','Resort entrance fountain'],
       ['الشبكات الداخلية وأعمال التشطيبات الصحية وشبكات المياه الساخنة والباردة','Internal networks, plumbing finishes, and hot and cold water networks']] },
 { c=>'pools', t=>['قرية بياسيرا — العين السخنة','Piacera Resort — Ain Sokhna'],
   d=>[['المملوكة لشركة الأهلي للتنمية والاستثمار','Owned by Al Ahly for Development & Investment'],
       ['عدد 6 حمامات سباحة','6 swimming pools']] },
 { c=>'pools', t=>['مدرسة مودرن سكول — القاهرة','Modern School — Cairo'],
   d=>[['حمام سباحة اسكيمر','Skimmer pool'],
       ['ومعهد محمد جلال الأزهري — حمام سباحة','And Mohamed Galal Al-Azhari Institute — swimming pool']] },
 { c=>'pools', t=>['بورتو السخنة — شركة عامر جروب','Porto Sokhna — Amer Group'],
   d=>[['المرحلة الأولى (الأبراج): عدد 3 حمامات سباحة — مقاول باطن','Phase one (The Towers): 3 swimming pools — as subcontractor'],
       ['المرحلة الثانية: عدد 9 حمامات سباحة — مقاول باطن','Phase two: 9 swimming pools — as subcontractor'],
       ['توريد وتركيب الأعمال الكهروميكانيكية لمعدات حمام سباحة بمنطقة البانوراما','Supply and installation of electromechanical works for the Panorama pool equipment'],
       ['أعمال إلكتروميكانيك لفلتر مياه بحيرة أسفل المركز التجاري — مشروع الأبراج','Electromechanical works for the lagoon filter beneath the commercial centre — Towers project'],
       ['معالجة الجسم الخارجي ومنع التسرب وتشغيل وتسليم الجواكيز الداخلية والخارجية لوحدات البنت هاوس','External shell treatment, waterproofing, commissioning and handover of the indoor and outdoor jacuzzis for the penthouse units'],
       ['توريد وتركيب جريلات الأوفر فلو — جولف بورتو السخنة','Supply and installation of overflow grating — Porto Sokhna Golf'],
       ['توريد وتركيب جريلات الأوفر فلو — جولف بورتو مارينا','Supply and installation of overflow grating — Porto Marina Golf'],
       ['توريد وتركيب سلالم حمام السباحة الرئيسي — بورتو كايرو','Supply and installation of the main pool ladders — Porto Cairo'],
       ['إعادة تهيئة نوافير المدينة العتيقة بالأسكاي مول','Refurbishment of the Old Town fountains at Sky Mall'],
       ['تأسيس وتنفيذ حمامات سباحة متكاملة بوحدة فلترة ومسخنة بفيلات منطقة الهاند 1','Complete pools with filtration and heating units for the Hand 1 villas'],
       ['أعمال اختبار شبكات بحيرة بورتو مارينا — العلمين','Network testing for the Porto Marina lagoon — El Alamein'],
       ['حلول ميكانيكية لحمام سباحة بمنطقة الهاوين — بورتو جولف السخنة','Mechanical remediation for a pool in the Hawain area — Porto Golf Sokhna'],
       ['حلول ميكانيكية لحمامي سباحة بالمرحلة الأولى — بورتو ساوث بيتش','Mechanical remediation for two phase-one pools — Porto South Beach']] },
 { c=>'pools', t=>['قرية موسى كوست — رأس سدر','Moses Coast Resort — Ras Sudr'], d=>[] },
 { c=>'pools', t=>['المدرسة البريطانية الدولية','British International School'], d=>[] },
 { c=>'pools', t=>['مول سيتي ستارز — مدينة نصر','City Stars Mall — Nasr City'],
   d=>[['عدد 7 نوافير','7 fountains']] },
 { c=>'pools', t=>['ألف ليلة وليلة — شرم الشيخ','Alf Leila Wa Leila — Sharm El Sheikh'],
   d=>[['جميع الأعمال المائية الموجودة بها من شلالات ونوافير','All water features on site, waterfalls and fountains alike']] },
 { c=>'pools', t=>['نادي جزيرة الورد — المنصورة','Gezirat El Ward Club — Mansoura'],
   d=>[['النادي الصحي','Health club'],['مغطس','Plunge pool'],['غرفة سونا','Sauna room'],['حمام سباحة','Swimming pool']] },
 { c=>'pools', t=>['مدرسة بايونيرز للغات — 6 أكتوبر','Pioneers Language School — 6th of October'],
   d=>[['عدد 2 حمام سباحة','2 swimming pools']] },
 { c=>'pools', t=>['مجموعة فيلات خاصة','Private villa portfolio'],
   d=>[['القاهرة الجديدة ومدينة العبور و6 أكتوبر والساحل الشمالي وشرم الشيخ','New Cairo, Obour City, 6th of October, the North Coast and Sharm El Sheikh']] },
 { c=>'pools', t=>['النادي الأهلي — الجزيرة','Al Ahly Club — Gezira'],
   d=>[['تعديلات في غرفة المعدات','Plant-room modifications']] },
 { c=>'pools', t=>['النادي الأهلي — مدينة نصر','Al Ahly Club — Nasr City'],
   d=>[['تعديلات في غرفة المعدات','Plant-room modifications']] },
 { c=>'pools', t=>['نادي الجزيرة الرياضي','Gezira Sporting Club'],
   d=>[['تعديلات في غرفة المعدات','Plant-room modifications']] },
 { c=>'pools', t=>['المدرسة الإنجليزية الحديثة — مصر الجديدة','Modern English School — Heliopolis'],
   d=>[['تعديلات في غرفة المعدات','Plant-room modifications']] },
 { c=>'pools', t=>['نادي المؤسسة العمالية','Workers\' Foundation Club'],
   d=>[['وحدة نظافة متحركة','Mobile cleaning unit']] },
 { c=>'pools', t=>['قرية طيبة البشرى — مركز شباب الخطاطبة','Taiba El Boshra — Khatatba Youth Centre'],
   d=>[['أعمال معالجة مياه وخزانات المياه','Water treatment works and water tanks']] },
 { c=>'pools', t=>['المبنى الإداري لشركة الأهلي للتنمية العقارية','Al Ahly Real Estate Development headquarters'],
   d=>[['تنفيذ أعمال النوافير وإضاءة اللاندسكيب','Fountains and landscape lighting']] },
 { c=>'pools', t=>['أسكاي مول — بورتو السخنة','Sky Mall — Porto Sokhna'],
   d=>[['تنفيذ أعمال الإلكتروميكانيك لنوافير المدينة العتيقة','Electromechanical works for the Old Town fountains']] },
 { c=>'pools', t=>['متحف دول حوض النيل — أسوان','Nile Basin Countries Museum — Aswan'],
   d=>[['الأعمال الإنشائية والإلكتروميكانيكية لنافورة وباثيو المتحف','Structural and electromechanical works for the museum fountain and patio'],
       ['منفذ من خلال وزارة الموارد المائية والري','Delivered through the Ministry of Water Resources and Irrigation']] },
 { c=>'intl', t=>['حمامات سباحة — دولة قطر','Swimming pools — Qatar'], d=>[] },
 { c=>'intl', t=>['محطات تحلية مياه — السودان','Desalination plants — Sudan'], d=>[] },
 { c=>'san', t=>['قرية غناظة — شرم الشيخ','Ghazala Resort — Sharm El Sheikh'],
   d=>[['توريد وتركيب الشبكات الخارجية للتغذية والصرف والحريق','Supply and installation of the external supply, drainage and firefighting networks'],
       ['الشبكات الداخلية والصحي الداخلي من التأسيس حتى التشطيب لكافة القطاعات: المباني والمطاعم والنادي الصحي','Internal networks and plumbing from first fix to finish across every sector: buildings, restaurants and the health club']] },
 { c=>'san', t=>['قرية شارمينج هيلز — شرم الشيخ','Charming Hills Resort — Sharm El Sheikh'],
   d=>[['توريد وتركيب الشبكات الخارجية للتغذية والصرف والحريق','Supply and installation of the external supply, drainage and firefighting networks'],
       ['الشبكات الداخلية والصحي الداخلي من التأسيس حتى التشطيب لكافة القطاعات','Internal networks and plumbing from first fix to finish across every sector']] },
 { c=>'san', t=>['قرية الربيع — شرم الشيخ','El Rabie Resort — Sharm El Sheikh'],
   d=>[['الشبكات الداخلية والحريق والصحي الداخلي من التأسيس حتى التشطيب لكافة القطاعات','Internal, firefighting and plumbing networks from first fix to finish across every sector']] },
 { c=>'san', t=>['مشروع كوزموس — التجمع الأول','Cosmos Project — First Settlement'],
   d=>[['المبنى الإداري لشركة السويدي','El Sewedy headquarters building'],
       ['شبكات الصحي والحريق والنوافير وشبكات الزراعة','Plumbing, firefighting, fountain and irrigation networks']] },
 { c=>'san', t=>['عقارات متعددة — القاهرة والجيزة','Multiple properties — Cairo and Giza'],
   d=>[['عمليات الإحلال والتجديد لأعمال الصحي الخارجي والداخلي','Replacement and renewal of external and internal plumbing'],
       ['خزانات المياه وطلمبات الرفع','Water tanks and lifting pumps']] },
);

# ------------------------------------------------------------
#  The company's own full service list (verbatim from the profile)
# ------------------------------------------------------------
@FULLSERVICES = (
  ['تصميم حمامات السباحة والنوافير','Swimming pool and fountain design'],
  ['تصميم كامل وعمل الحسابات الخاصة بمعدات وشبكات حمامات السباحة وتقديم الرسومات الخاصة بها','Complete design and calculations for pool equipment and networks, issued with drawings'],
  ['توريد وتركيب معدات ومستلزمات حمامات السباحة والجاكوزي والهيدروبول','Supply and installation of pool, jacuzzi and hydropool equipment and supplies'],
  ['توريد وتركيب الجاكوزي الجاهز','Supply and installation of prefabricated jacuzzis'],
  ['توريد وتركيب النوافير والشلالات','Supply and installation of fountains and waterfalls'],
  ['توريد وتركيب غرف السونا','Supply and installation of sauna rooms'],
  ['توريد وتركيب غرف البخار','Supply and installation of steam rooms'],
  ['توريد وتركيب محطات معالجة مياه الصرف','Supply and installation of wastewater treatment plants'],
  ['توريد وتركيب محطات تنقية مياه الشرب وتحلية مياه البحر','Supply and installation of drinking-water treatment and seawater desalination plants'],
  ['إنشاء وتشطيب وعزل حمامات السباحة','Pool construction, finishing and waterproofing'],
  ['تفريغ وشحن الوسط الترشيحي للفلاتر','Emptying and recharging of filter media'],
  ['توريد وتركيب طلمبات الرفع بجميع أنواعها','Supply and installation of lifting pumps of every type'],
  ['القيام بجميع أعمال التركيبات الخاصة بحمامات السباحة ومحطات المياه والشبكات','All installation works for pools, water plants and networks'],
  ['تصنيع فلاتر وتنكات المياه بجميع أنواعها','Manufacture of filters and water tanks of every type'],
  ['تنفيذ كافة الأعمال الخاصة بشبكات المياه بكافة أنواعها من ري وصرف وتغذية وحريق، خارجية وداخلية، تأسيس وتشطيب','All water network works — irrigation, drainage, supply and firefighting; external and internal, first fix to finish'],
  ['أعمال الصيانة الدورية','Scheduled maintenance'],
);

# ------------------------------------------------------------
#  How we work (new section)
# ------------------------------------------------------------
@PROCESS = (
  { n=>'01', t=>['تصميم وحسابات','Design & engineering'],
    d=>['رسومات تنفيذية وحسابات كاملة للمعدات والشبكات قبل أن يُصبّ متر واحد من الخرسانة.',
        'Working drawings and complete calculations for equipment and networks, before a single metre of concrete is poured.'] },
  { n=>'02', t=>['تنفيذ وتركيب','Build & install'],
    d=>['أعمال مدنية وكهروميكانيكية بفريق واحد، من التأسيس حتى التشغيل والتسليم.',
        'Civil and electromechanical works by one team, from first fix through commissioning and handover.'] },
  { n=>'03', t=>['تشغيل وصيانة','Operate & maintain'],
    d=>['متابعة الأداء وصيانة دورية لحمامات السباحة ومحطات التحلية بعد التسليم.',
        'Performance monitoring and scheduled maintenance for pools and desalination plants long after handover.'] },
);

# ------------------------------------------------------------
#  Where we have worked (derived from the works ledger)
# ------------------------------------------------------------
@LOCATIONS = (
  ['شرم الشيخ','Sharm El Sheikh'], ['الغردقة','Hurghada'], ['العين السخنة','Ain Sokhna'],
  ['الساحل الشمالي','North Coast'], ['العلمين','El Alamein'], ['رأس سدر','Ras Sudr'],
  ['القاهرة','Cairo'], ['الجيزة','Giza'], ['6 أكتوبر','6th of October'],
  ['المنصورة','Mansoura'], ['المنيا','Minya'], ['أسوان','Aswan'],
  ['قطر','Qatar'], ['السودان','Sudan'],
);

# ------------------------------------------------------------
#  Gallery (order preserved from the original album)
# ------------------------------------------------------------
@GALLERY = qw(
  aquamarine1.jpeg aquamarine2.jpg aquamarine3.jpg aquamarine4.jpg aquamarine5.jpg
  aquamarine6.jpg aquamarine7.jpg aquamarine8.jpg aquamarine9.jpg aquamarine10.jpg
  aquamarine11.jpg aquamarine14.jpg aquamarine15.jpg aquamarine16.jpg aquamarine19.jpg
  aquamarine18.jpg aquamarine20.jpg aquamarine21.jpg
);
push @GALLERY, 'aquamarine12(1).jpg';
push @GALLERY, qw(
  aquamarine22.jpg aquamarine23.jpg aquamarine24.jpg aquamarine25.jpg aquamarine26.jpg
  aquamarine27.jpg aquamarine29.jpg aquamarine28.jpg
);

# ------------------------------------------------------------
#  Navigation  [file, label pair, has-submenu]
# ------------------------------------------------------------
@NAV = (
  ['index.html',    ['الرئيسية','Home']],
  ['about.html',    ['من نحن','About']],
  ['services.html', ['الخدمات','Services'], 'sub'],
  ['projects.html', ['المشروعات','Projects']],
  ['works.html',    ['سابقة الأعمال','Track Record']],
  ['gallery.html',  ['ألبوم الصور','Gallery']],
  ['videos.html',   ['الفيديوهات','Video']],
  ['contact.html',  ['اتصل بنا','Contact']],
);

# ------------------------------------------------------------
#  UI strings
# ------------------------------------------------------------
%T = (
  # global
  order_now      => ['اطلب الآن','Request a quote'],
  menu           => ['القائمة','Menu'],
  close          => ['إغلاق','Close'],
  home           => ['الرئيسية','Home'],
  support_24     => ['خدمة العملاء على مدار اليوم','Customer service around the clock'],
  profile        => ['بروفايل الشركة','Company profile'],
  profile_full   => ['بروفايل الشركة الكامل','Full company profile'],
  profile_sub    => ['ملف PDF — سابقة الأعمال والخدمات التفصيلية','PDF — track record and detailed services'],
  whatsapp       => ['واتساب','WhatsApp'],
  email_label    => ['البريد الإلكتروني','Email'],
  phone_label    => ['الهاتف','Phone'],
  address_label  => ['العنوان','Address'],
  all_rights     => ['جميع الحقوق محفوظة','All rights reserved'],
  site_links     => ['روابط الموقع','Site links'],
  our_services   => ['خدماتنا','Our services'],
  all_services   => ['كل الخدمات','All services'],
  all_projects   => ['كل المشروعات','All projects'],
  all_photos     => ['كل الصور','All photos'],
  newsletter     => ['النشرة البريدية','Newsletter'],
  newsletter_p   => ['اشترك لتلقي آخر الأخبار حول خدماتنا ومشروعاتنا.','Subscribe for news about our services and projects.'],
  newsletter_ph  => ['أدخل بريدك الإلكتروني','Enter your email'],
  subscribe      => ['اشترك','Subscribe'],
  subscribed     => ['تم الاشتراك ✓','Subscribed ✓'],
  footer_blurb   => ['شركة متخصصة في أعمال المياه: إنشاء وصيانة حمامات السباحة، النوافير والشلالات، محطات التنقية والمعالجة، وشبكات المياه والحريق بجميع أنواعها.',
                     'A specialist water contractor: pool construction and maintenance, fountains and waterfalls, treatment and desalination plants, and water and firefighting networks of every kind.'],
  to_top         => ['أعلى الصفحة','Back to top'],
  call_us        => ['اتصل بنا','Call us'],

  # hero
  hero_a         => ['نبني الماء','We build water'],
  hero_b         => ['كما يجب أن يكون','the way it should be'],
  hero_lead      => ['شركة متخصصة في أعمال المياه: إنشاء وصيانة حمامات السباحة الخاصة والعامة وحمامات النوادي الرياضية، وشبكات مياه الشرب والصرف والري والحريق، ومحطات التنقية والمعالجة.',
                     'A specialist water contractor: private, public and sporting-club swimming pools; drinking water, drainage, irrigation and firefighting networks; treatment and desalination plants.'],
  browse_services=> ['تصفح خدماتنا','Explore our services'],
  track_record   => ['سابقة الأعمال','Track record'],
  scroll         => ['SCROLL','SCROLL'],

  # stats
  stat_projects  => ['مشروعاً في سابقة الأعمال','projects on record'],
  stat_pools     => ['حمام سباحة ونافورة','pools and fountains'],
  stat_services  => ['خدمات هندسية متخصصة','specialist services'],
  stat_countries => ['دول عمل','countries'],
  stat_countries2=> ['دول: مصر وقطر والسودان','countries: Egypt, Qatar, Sudan'],
  stat_support   => ['خدمة عملاء ودعم فني','support and service'],

  # about
  about_h        => ['مرحباً بكم في شركة أكوا مارين ووتر سيستمز','Welcome to Aqua Marine Water Systems'],
  about_lead     => ['نحن شركة تعمل في مجال المياه بصفة عامة، متخصصون في أعمال إنشاء وصيانة حمامات السباحة الخاصة والعامة وحمامات سباحة النوادي الرياضية.',
                     'We work across the water sector, specialising in the construction and maintenance of private, public and sporting-club swimming pools.'],
  about_lead2    => ['نحن شركة تعمل في مجال المياه بصفة عامة.','We work across the water sector.'],
  about_t1       => ['أعمال شبكات مياه الشرب والصرف الصحي والري والحريق والمياه الساخنة للغرف الفندقية بجميع أنواعها — UPVC و PPR و HDPE.',
                     'Drinking water, sewerage, irrigation, firefighting and hotel hot-water networks of every type — UPVC, PPR and HDPE.'],
  about_t2       => ['إنشاء شبكات مكافحة الحريق الداخلية وأعمال الصحي الداخلي (السباكة الداخلية).',
                     'Internal firefighting networks and internal plumbing works.'],
  about_t3       => ['تصميم كامل وعمل الحسابات الخاصة بمعدات وشبكات حمامات السباحة وتقديم الرسومات الخاصة بها.',
                     'Complete design and calculations for pool equipment and networks, issued with drawings.'],
  about_t4       => ['أعمال الصيانة الدورية لحمامات السباحة ومحطات التحلية.',
                     'Scheduled maintenance for swimming pools and desalination plants.'],
  learn_more     => ['تعرّف علينا أكثر','More about us'],
  badge_sub      => ['مشروعاً مرجعياً<br>داخل مصر وخارجها','reference projects<br>in Egypt and abroad'],
  who_we_are     => ['من نحن','About us'],
  what_we_do     => ['خدمات شركة أكوا مارين ووتر سيستمز','What Aqua Marine does'],
  service_detail_cta => ['تفاصيل كل خدمة','Service details'],
  numbers_h      => ['أرقام تختصر خبرتنا','Our record in numbers'],

  # services
  services_h     => ['خدمات متكاملة تحت سقف واحد','Complete services under one roof'],
  services_lead  => ['من التصميم والحسابات الهندسية حتى التنفيذ والتشغيل والصيانة الدورية.',
                     'From design and engineering calculations through construction, commissioning and scheduled maintenance.'],
  service_details=> ['تفاصيل الخدمة','Service details'],
  services_intro => ['توريد جميع معدات ومستلزمات حمامات السباحة ومحطات المعالجة والوسط الترشيحي للفلاتر وطلمبات الرفع بجميع أنواعها، والقيام بجميع أعمال التركيبات الخاصة بحمامات السباحة ومحطات المياه والشبكات وتصنيع فلاتر وتنكات المياه، كما تقوم الشركة بأعمال الصيانة الدورية لحمامات السباحة ومحطات التحلية.',
                     'We supply all pool and treatment-plant equipment, filter media and lifting pumps of every type; carry out every installation for pools, water plants and networks; manufacture filters and water tanks; and provide scheduled maintenance for pools and desalination plants.'],
  services_list_h=> ['خدمات شركة أكوا مارين','What Aqua Marine does'],
  order_service  => ['اطلب هذه الخدمة','Request this service'],
  quote_note     => ['للحصول على عرض سعر لهذه الخدمة، يمكنك','To get a quote for this service, you can'],
  quote_note2    => ['تسجيل طلبك','submit a request'],
  quote_note3    => ['أو الاتصال على','or call'],

  # process
  process_h      => ['كيف نعمل','How we work'],
  process_lead   => ['مسار واحد من أول رسمة حتى ما بعد التسليم — بفريق واحد ومسؤولية واحدة.',
                     'One path from the first drawing to long after handover — one team, one line of responsibility.'],

  # locations
  locations_h    => ['أين عملنا','Where we have worked'],
  locations_lead => ['مشروعات منفذة في منتجعات وفنادق ومدارس وأندية ومنشآت صناعية.',
                     'Delivered across resorts, hotels, schools, clubs and industrial facilities.'],

  # projects
  projects_h     => ['مشروعات نفخر بتنفيذها','Projects we are proud of'],
  projects_lead  => ['منتجعات وفنادق ومدارس وأندية ومنشآت صناعية في مصر والخليج.',
                     'Resorts, hotels, schools, clubs and industrial facilities across Egypt and the Gulf.'],
  view_project   => ['عرض المشروع','View project'],
  other_projects => ['مشروعات أخرى','Other projects'],
  from_projects  => ['من مشروعاتنا','From our projects'],

  # works
  works_h        => ['أعمال منفذة','Delivered works'],
  works_lead     => ['هذا علاوة على إمكانية إنشاء كافة أنواع حمامات السباحة من أعمال مدنية وتشطيبات وأعمال كهروميكانيكية، والقيام بكافة الأعمال الصحية الداخلية والخارجية وأعمال شبكات مكافحة الحريق.',
                     'Alongside this we build swimming pools of every kind — civil works, finishes and electromechanical works — and carry out all internal and external plumbing and firefighting network works.'],
  works_intro    => ['قائمة تفصيلية بمشروعات الشركة داخل جمهورية مصر العربية وخارجها.',
                     'A detailed record of the company\'s projects inside Egypt and abroad.'],
  filter_all     => ['الكل','All'],
  full_record    => ['سابقة أعمال كاملة','The full record'],
  full_record_p  => ['قائمة تفصيلية بأعمال الشركة في حمامات السباحة والنوافير والشلالات والنوادي الصحية والأعمال الصحية وشبكات الري والصرف والحريق.',
                     'A detailed list of our works across pools, fountains, waterfalls and health clubs, plus plumbing and irrigation, drainage and firefighting networks.'],
  browse_list    => ['استعرض القائمة','Browse the list'],

  # gallery / video
  gallery_h      => ['ألبوم الصور','Gallery'],
  gallery_lead   => ['معرض لمجموعة من أميز أعمالنا الإبداعية.','A selection of our finest work.'],
  zoom           => ['تكبير الصورة','Enlarge'],
  prev           => ['السابق','Previous'],
  next           => ['التالي','Next'],
  video_h        => ['شاهد أكوا مارين في العمل','See Aqua Marine at work'],
  video_lead     => ['جولة قصيرة داخل بعض مشروعاتنا المنفذة.','A short tour through some of our completed projects.'],
  video_page_h   => ['الفيديوهات','Video'],
  video_page_lead=> ['جولة داخل بعض مشروعات أكوا مارين ووتر سيستمز.','A tour through some of Aqua Marine\'s projects.'],
  video_sub      => ['فيديو تعريفي بأعمال الشركة','Company introduction film'],
  watch_yt       => ['مشاهدة على يوتيوب','Watch on YouTube'],
  play           => ['تشغيل الفيديو','Play video'],

  # cta
  cta_h          => ['اتصل بشركة أكوا مارين ووتر سيستمز','Talk to Aqua Marine Water Systems'],
  cta_lead       => ['فريقنا متاح على مدار اليوم للإجابة على جميع استفساراتك وتقديم عرض السعر المناسب لمشروعك.',
                     'Our team is available around the clock to answer your questions and price your project.'],

  # contact / order
  contact_h      => ['اتصل بنا','Contact us'],
  contact_lead   => ['فريقنا متاح على مدار اليوم للإجابة على جميع استفساراتك.','Our team is available around the clock to answer your questions.'],
  send_message   => ['تواصل معنا','Send us a message'],
  send_btn       => ['إرسال الرسالة','Send message'],
  map_h          => ['موقعنا على الخريطة','Find us on the map'],
  map_title      => ['موقع شركة أكوا مارين على الخريطة','Aqua Marine Water Systems location'],
  wa_cta         => ['تواصل عبر واتساب','Message us on WhatsApp'],
  order_h        => ['سجّل طلبك','Submit your request'],
  order_lead     => ['سجّل طلبك وسيتواصل معك فريقنا في أقرب وقت.','Submit your request and our team will be in touch shortly.'],
  order_btn      => ['تسجيل الطلب','Submit request'],
  prefer_call    => ['تفضل الاتصال المباشر؟','Prefer to talk directly?'],

  # form fields
  f_name         => ['الاسم','Name'],
  f_name_ph      => ['الاسم بالكامل','Full name'],
  f_name_err     => ['من فضلك أدخل الاسم','Please enter your name'],
  f_phone        => ['الموبايل','Mobile'],
  f_phone_err    => ['من فضلك أدخل رقم الموبايل','Please enter your mobile number'],
  f_email        => ['البريد الإلكتروني','Email'],
  f_email_err    => ['من فضلك أدخل بريداً صحيحاً','Please enter a valid email'],
  f_city         => ['المحافظة / الموقع','Governorate / location'],
  f_city_ph      => ['مثال: القاهرة الجديدة','e.g. New Cairo'],
  f_service      => ['اختيار الخدمة','Choose a service'],
  f_service_ph   => ['— اختر الخدمة —','— select a service —'],
  f_service_err  => ['من فضلك اختر الخدمة','Please choose a service'],
  f_message      => ['الرسالة','Message'],
  f_message_ph   => ['اكتب استفسارك أو تفاصيل مشروعك...','Tell us about your enquiry or your project...'],
  f_message_err  => ['من فضلك اكتب رسالتك','Please write your message'],
  f_details      => ['تفاصيل الطلب','Request details'],
  f_details_ph   => ['اكتب تفاصيل المشروع: المساحة، الموقع، الجدول الزمني...','Project details: size, location, timeline...'],
  f_details_err  => ['من فضلك اكتب تفاصيل الطلب','Please describe your request'],
  f_sum          => ['للتأكيد، ما ناتج','To confirm you are human, what is'],
  f_sum_err      => ['الإجابة غير صحيحة','That answer is not correct'],
  f_sum_reload   => ['سؤال آخر','Another question'],
  f_sum_aria     => ['ناتج الجمع','Sum result'],
  form_ok        => ['تم تجهيز رسالتك وفتحها في واتساب لإرسالها إلى فريقنا. إذا لم تفتح النافذة تلقائياً، من فضلك اتصل بنا مباشرة.',
                     'Your message has been prepared and opened in WhatsApp to send to our team. If the window did not open, please call us directly.'],
  form_note      => ['هذا الموقع نسخة ثابتة بدون خادم بريد؛ يتم تحويل بيانات النموذج إلى واتساب الشركة لإرسالها مباشرة. يمكنك أيضاً مراسلتنا على البريد الإلكتروني.',
                     'This is a static site with no mail server; form details are handed to the company WhatsApp to send directly. You are welcome to email us instead.'],
  wa_subject_c   => ['رسالة من نموذج (اتصل بنا)','Message from the contact form'],
  wa_subject_o   => ['طلب خدمة من الموقع','Service request from the website'],
  wa_name        => ['الاسم','Name'],
  wa_phone       => ['الموبايل','Mobile'],
  wa_email       => ['الإيميل','Email'],
  wa_service     => ['الخدمة','Service'],
  wa_city        => ['المحافظة','Location'],

  # meta
  meta_home      => ['شركة أكوا مارين ووتر سيستمز: تصميم وإنشاء وصيانة حمامات السباحة، النوافير والشلالات، محطات تنقية مياه الشرب ومعالجة الصرف، غرف السونا والبخار، وشبكات المياه والحريق.',
                     'Aqua Marine Water Systems: design, construction and maintenance of swimming pools, fountains and waterfalls, water treatment and desalination plants, saunas and steam rooms, and water and firefighting networks.'],
  meta_home_t    => ['حمامات سباحة ومحطات مياه ونوافير','Swimming pools, water plants and fountains'],
  meta_about     => ['تعرف على شركة أكوا مارين ووتر سيستمز: التخصصات والخدمات وسابقة الأعمال في مجال حمامات السباحة وشبكات ومحطات المياه.',
                     'About Aqua Marine Water Systems: our specialisms, services and track record in swimming pools, water networks and treatment plants.'],
  meta_services  => ['خدمات أكوا مارين: تصميم وإنشاء حمامات السباحة، النوافير والشلالات، محطات تنقية ومعالجة المياه، طلمبات الرفع، غرف السونا والبخار، وشبكات المياه.',
                     'Aqua Marine services: pool design and construction, fountains and waterfalls, water treatment and desalination plants, lifting pumps, saunas and steam rooms, and water networks.'],
  meta_projects  => ['مشروعات أكوا مارين ووتر سيستمز: بورتو السخنة، ألف ليلة وليلة شرم الشيخ، كونتننتال الغردقة، مدرسة القاهرة الإنجليزية الحديثة وغيرها.',
                     'Aqua Marine projects: Porto Sokhna, Alf Leila Wa Leila Sharm El Sheikh, Continental Hurghada, Cairo Modern English School and more.'],
  meta_works     => ['سابقة أعمال شركة أكوا مارين ووتر سيستمز في حمامات السباحة والنوافير والشلالات والنوادي الصحية وشبكات الري والصرف والحريق داخل مصر وخارجها.',
                     'The Aqua Marine Water Systems track record across swimming pools, fountains, waterfalls, health clubs and irrigation, drainage and firefighting networks in Egypt and abroad.'],
  meta_gallery   => ['معرض صور أعمال شركة أكوا مارين ووتر سيستمز: حمامات السباحة والنوافير والشلالات ومحطات المياه.',
                     'Photo gallery of Aqua Marine Water Systems projects: swimming pools, fountains, waterfalls and water plants.'],
  meta_videos    => ['فيديوهات أعمال شركة أكوا مارين ووتر سيستمز.','Video of Aqua Marine Water Systems projects.'],
  meta_contact   => ['تواصل مع شركة أكوا مارين ووتر سيستمز: العنوان وأرقام الهاتف والبريد الإلكتروني ونموذج المراسلة.',
                     'Contact Aqua Marine Water Systems: address, phone numbers, email and enquiry form.'],
  meta_order     => ['سجل طلب خدمة من شركة أكوا مارين ووتر سيستمز: حمامات سباحة، نوافير، محطات مياه، غرف سونا وبخار، شبكات مياه.',
                     'Request a service from Aqua Marine Water Systems: swimming pools, fountains, water plants, saunas and steam rooms, water networks.'],
);

# ------------------------------------------------------------
#  Per-service "what this covers" points
# ------------------------------------------------------------
our %SVC_FEATURES = (
  'pool-design'     => [['حسابات المعدات والشبكات','Equipment and pipework calculations'],
                        ['رسومات تنفيذية كاملة','Complete working drawings'],
                        ['تصميم النوافير والشلالات','Fountain and water-feature design']],
  'pool-build'      => [['أعمال مدنية وخرسانية','Civil and concrete works'],
                        ['عزل ومنع تسرب','Waterproofing and leak prevention'],
                        ['تشطيبات وتركيب المعدات','Finishes and equipment installation']],
  'fountains'       => [['نوافير لاندسكيب ومداخل','Landscape and entrance fountains'],
                        ['شلالات وواجهات مائية','Waterfalls and water walls'],
                        ['إضاءة ولوحات تحكم','Lighting and control panels']],
  'water-treatment' => [['تحلية مياه البحر','Seawater desalination'],
                        ['تنقية مياه الشرب','Drinking water treatment'],
                        ['تصنيع فلاتر وتنكات','Filter and tank manufacture']],
  'sewage'          => [['محطات معالجة متكاملة','Complete treatment plants'],
                        ['تفريغ وشحن الوسط الترشيحي','Filter media replacement'],
                        ['تشغيل وصيانة دورية','Operation and scheduled maintenance']],
  'pumps'           => [['طلمبات رفع وحريق','Lifting and firefighting pumps'],
                        ['غرف معدات ولوحات تحكم','Plant rooms and control panels'],
                        ['صيانة دورية','Scheduled maintenance']],
  'steam-rooms'     => [['غرف بخار للفنادق والنوادي','Steam rooms for hotels and clubs'],
                        ['مولدات بخار ووحدات تحكم','Steam generators and control units'],
                        ['تشطيبات وعزل حراري','Finishes and thermal insulation']],
  'sauna-rooms'     => [['غرف سونا خشبية','Timber sauna cabins'],
                        ['سخانات وتحكم حراري','Heaters and thermal control'],
                        ['تركيب وتشغيل وتسليم','Installation, commissioning and handover']],
  'water-networks'  => [['شبكات تغذية وصرف','Supply and drainage networks'],
                        ['شبكات ري ومكافحة حريق','Irrigation and firefighting networks'],
                        ['UPVC · PPR · HDPE','UPVC · PPR · HDPE']],
);

# ------------------------------------------------------------
#  Per-project facts + which @WORKS entries describe them
# ------------------------------------------------------------
our %PROJ_FACTS = (
  'porto-sokhna'         => { loc=>['العين السخنة','Ain Sokhna'],         client=>['عامر جروب','Amer Group'],        scope=>['12 حمام سباحة + نوافير','12 pools + fountains'] },
  'alf-leila-sharm'      => { loc=>['شرم الشيخ','Sharm El Sheikh'],       client=>['—','—'],                          scope=>['شلالات ونوافير','Waterfalls and fountains'] },
  'continental-hurghada' => { loc=>['الغردقة','Hurghada'],                client=>['—','—'],                          scope=>['حمامات سباحة وشبكات','Pools and networks'] },
  'cairo-modern-school'  => { loc=>['ميراج سيتي ومصر الجديدة','Mirage City & Heliopolis'], client=>['—','—'],          scope=>['حمام سباحة أوليمبي','Olympic swimming pool'] },
  'villa-marina'         => { loc=>['الساحل الشمالي','North Coast'],      client=>['—','—'],                          scope=>['حمام سباحة متكامل','Complete swimming pool'] },
  'sokhna-sugar-factory' => { loc=>['العين السخنة','Ain Sokhna'],         client=>['—','—'],                          scope=>['معالجة مياه وشبكات','Water treatment and networks'] },
);

# indices into @WORKS whose detail lines describe each project
our %PROJ_WORKS = (
  'porto-sokhna'        => [14, 29],
  'alf-leila-sharm'     => [18],
  'cairo-modern-school' => [4, 25],
  'villa-marina'        => [21],
);

# fallback scope lines for projects with no matching ledger entry
our @GENERIC_SCOPE = (
  ['توريد وتركيب معدات حمامات السباحة والمعالجة','Supply and installation of pool and treatment equipment'],
  ['تنفيذ شبكات التغذية والصرف والحريق','Supply, drainage and firefighting networks'],
  ['التشغيل والتسليم والصيانة الدورية','Commissioning, handover and scheduled maintenance'],
);

# ------------------------------------------------------------
#  Extra UI strings for the richer page layouts
# ------------------------------------------------------------
$T{whats_included} = ['ما تشمله الخدمة','What this covers'];
$T{scope_h}        = ['نطاق الأعمال','Scope of works'];
$T{from_our_work}  = ['من أعمالنا','From our work'];
$T{from_our_work_l}= ['لقطات من مواقع التنفيذ ومشروعات مسلّمة.','Shots from live sites and delivered projects.'];
$T{overview}       = ['نظرة عامة','Overview'];
$T{prev_item}      = ['السابق','Previous'];
$T{next_item}      = ['التالي','Next'];
$T{fact_type}      = ['نوع المشروع','Project type'];
$T{fact_loc}       = ['الموقع','Location'];
$T{fact_client}    = ['العميل','Client'];
$T{fact_scope}     = ['النطاق','Scope'];
$T{band_h}         = ['من التصميم إلى التشغيل — بفريق واحد','From drawing to commissioning — one team'];
$T{band_lead}      = ['نتولى الأعمال المدنية والكهروميكانيكية والصحية معاً، فلا تتوزع المسؤولية بين مقاولين.',
                      'We carry the civil, electromechanical and plumbing works together, so responsibility never splits between contractors.'];
$T{related_svc}    = ['خدمات ذات صلة','Related services'];
$T{all_works}      = ['كل الأعمال','All works'];
$T{gallery_note}   = ['اضغط أي صورة لعرضها بالحجم الكامل.','Click any photo to view it full size.'];
$T{video_related}  = ['تصفح المزيد','Browse further'];
$T{jump_overview}  = ['نظرة عامة','Overview'];
$T{jump_included}  = ['ما تشمله','What it covers'];
$T{jump_work}      = ['من أعمالنا','Our work'];
$T{jump_projects}  = ['مشروعات','Projects'];
$T{jump_scope}     = ['نطاق الأعمال','Scope'];
$T{jump_contact}   = ['تواصل','Contact'];

# ------------------------------------------------------------
#  Photo albums — the gallery page filters by these.
#  `glob` albums pick up every matching file at build time, so new
#  photos only need dropping into assets/img/albatros/ and a rebuild.
#  Optional: cover=>'albatros/makadi-05.jpg' to choose the album cover.
# ------------------------------------------------------------
our @ALBUMS = (
  { slug=>'makadi',    glob=>'albatros/makadi-*.jpg',    t=>['ألباتروس مكادي','Albatros Makadi'] },
  { slug=>'portofino', glob=>'albatros/portofino-*.jpg', t=>['ألباتروس بورتوفينو','Albatros Portofino'] },
  { slug=>'citadel',   glob=>'albatros/citadel-*.jpg',   t=>['ألباتروس سيتادل','Albatros Citadel'] },
  { slug=>'resort',    glob=>'albatros/resort-*.jpg',    t=>['ألباتروس ريزورت','Albatros Resort'] },
  { slug=>'neverland', glob=>'albatros/neverland-*.jpg', t=>['ألباتروس نيفرلاند','Albatros Neverland'] },
  { slug=>'archive',   files=>[@GALLERY],                t=>['أرشيف أكوا مارين','Aqua Marine archive'] },
);

# ------------------------------------------------------------
#  Videos — `yt` for YouTube, `src` for a file in assets/video/
# ------------------------------------------------------------
our @VIDEOS = (
  { yt=>$C{ytid}, poster=>'a-3.jpg', link=>$C{yt}, t=>$C{name}, d=>$T{video_sub} },
  { src=>'albatros-resort.mp4', poster=>'albatros/resort-01.jpg',
    t=>['ألباتروس ريزورت','Albatros Resort'], d=>['لقطة من موقع المشروع','A clip from the project site'] },
);

$T{albums_h}    = ['ألبومات المشروعات','Project albums'];
$T{albums_lead} = ['صور من مشروعات منتجعات ألباتروس، إلى جانب أرشيف أعمال الشركة. اختر ألبوماً لعرض صوره فقط.',
                   'Photography from the Albatros resort projects, alongside the company archive. Pick an album to show only its photos.'];
$T{photos_word} = ['صورة','photos'];
$T{albums_word} = ['ألبومات','albums'];
$T{videos_word} = ['فيديو','videos'];

1;
