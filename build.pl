#!/usr/bin/perl
# ============================================================
#  AQUA MARINE WATER SYSTEMS — static site generator
#  Regenerate the whole site:   perl build.pl
#  Content lives in the DATA section below; markup in the
#  emitters underneath it. Output is plain static HTML.
# ============================================================
use strict;
use warnings;
use utf8;
binmode(STDOUT, ':encoding(UTF-8)');

my $OUT = '.';

# ============================================================
#  DATA — company
# ============================================================
my %C = (
  name      => 'أكوا مارين ووتر سيستمز',
  full      => 'شركة أكوا مارين ووتر سيستمز',
  addr      => '2 شارع العطار، بهتيم، شبرا الخيمة، القليوبية',
  mobile    => '01006637481',
  mobile2   => '01005551386',
  intl      => '201006637481',
  land      => '202-42220220',
  wa        => '201006637481',
  email     => 'info' . '@' . 'aquamarine-ws.com',
  fb        => 'https://www.facebook.com/aquamarinewatersystem',
  ig        => 'https://www.instagram.com/',
  tw        => 'https://twitter.com/AquaMar48551844/status/1475483948558032901',
  yt        => 'https://www.youtube.com/watch?v=SmqweM1r7A0',
  li        => 'https://www.linkedin.com',
  ytid      => 'SmqweM1r7A0',
  map       => 'https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d215.66515326588038!2d31.279779304389386!3d30.133043084067662!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x3a82f39a060ab2ab!2sHyper%20Ferjany!5e0!3m2!1sen!2seg!4v1653566862459!5m2!1sen!2seg',
);

# ============================================================
#  DATA — services  [slug, title, blurb, image]
# ============================================================
my @SERVICES = (
  ['pool-design',     'تصميم حمامات السباحة والنوافير',
   'تصميم كامل وعمل الحسابات الخاصة بمعدات وشبكات حمامات السباحة وتقديم الرسومات الخاصة بها.',
   'aquamarine16(1).jpg'],
  ['pool-build',      'إنشاء وتشطيب وعزل حمامات السباحة',
   'أعمال مدنية وتشطيبات وعزل متكامل، مع توريد وتركيب معدات ومستلزمات حمامات السباحة والجاكوزي والهيدروبول.',
   'aquamarine26(1).jpg'],
  ['fountains',       'توريد وتركيب النوافير والشلالات',
   'تنفيذ النوافير والشلالات المائية بجميع أشكالها وأعمال الإضاءة واللاندسكيب المصاحبة لها.',
   'aquamarine1(1).jpeg'],
  ['water-treatment', 'محطات تنقية مياه الشرب وتحلية مياه البحر',
   'توريد وتركيب محطات تنقية مياه الشرب وتحلية مياه البحر، وتصنيع فلاتر وتنكات المياه بجميع أنواعها.',
   'aquamarine2(1).jpg'],
  ['sewage',          'محطات معالجة مياه الصرف',
   'توريد وتركيب محطات معالجة مياه الصرف، وتفريغ وشحن الوسط الترشيحي للفلاتر.',
   'aquamarine3(1).jpg'],
  ['pumps',           'طلمبات الرفع بجميع أنواعها',
   'توريد وتركيب طلمبات الرفع بجميع أنواعها وأعمال الصيانة الدورية اللازمة لها.',
   'aquamarine28(1).jpg'],
  ['steam-rooms',     'توريد وتركيب غرف البخار',
   'توريد وتركيب غرف البخار للفنادق والقرى السياحية والنوادي الصحية والفلل الخاصة.',
   '20080707319.jpg'],
  ['sauna-rooms',     'توريد وتركيب غرف السونا',
   'توريد وتركيب غرف السونا بمواصفات الفنادق والنوادي الصحية ووحدات الإقامة الخاصة.',
   '20070425(009)(2).jpg'],
  ['water-networks',  'الأعمال الخاصة بشبكات المياه',
   'تنفيذ شبكات المياه بكافة أنواعها من ري وصرف وتغذية وحريق، خارجية وداخلية، تأسيس وتشطيب.',
   'aquamarine22(1).jpg'],
);
my @AI = ('٠١','٠٢','٠٣','٠٤','٠٥','٠٦','٠٧','٠٨','٠٩');

# ============================================================
#  DATA — projects  [slug, title, tag, blurb, image]
# ============================================================
my @PROJECTS = (
  ['porto-sokhna', 'بورتو السخنة', 'RESORT',
   'مشروع الأبراج لشركة عامر جروب: 3 حمامات سباحة بالمرحلة الأولى و9 حمامات بالمرحلة الثانية، إلى جانب الأعمال الكهروميكانيكية لمنطقة البانوراما ونوافير المدينة العتيقة بالأسكاي مول.',
   'aquamarine25(1).jpg'],
  ['alf-leila-sharm', 'فندق ألف ليلة وليلة — شرم الشيخ', 'HOTEL',
   'تنفيذ جميع الأعمال المائية الموجودة بالفندق من شلالات ونوافير.',
   'aquamarine10(1).jpg'],
  ['continental-hurghada', 'كونتننتال الغردقة', 'HOTEL',
   'أعمال حمامات السباحة والمعدات الكهروميكانيكية وشبكات المياه بالمنشأة الفندقية.',
   'aquamarine23(1).jpg'],
  ['cairo-modern-school', 'مدرسة القاهرة الإنجليزية الحديثة', 'SCHOOL',
   'حمام سباحة أوليمبي بفرع ميراج سيتي، وأعمال تعديلات غرفة المعدات بفرع مصر الجديدة.',
   'aquamarine5(1).jpg'],
  ['villa-marina', 'فيلا خاصة — مارينا', 'VILLA',
   'حمام سباحة متكامل بأعماله المدنية والكهروميكانيكية ضمن أعمال الفلل الخاصة بالساحل الشمالي.',
   'aquamarine29(1).jpg'],
  ['sokhna-sugar-factory', 'مصنع السكر — السخنة', 'INDUSTRIAL',
   'أعمال معالجة المياه وشبكات التغذية والصرف الصناعية بالمصنع.',
   'eeee.jpg'],
);

# ============================================================
#  DATA — previous works ledger (from the company profile)
#  [category, title, [details...]]
# ============================================================
my @WORKS = (
  ['pools','مديرية التربية والتعليم بالمنيا',['إنشاء الحمام وتوريد جميع معداته']],
  ['pools','مركز شباب ناصر',['إنشاء وتركيب حمام سباحة (أوليمبي)']],
  ['pools','سيراميكا كليوباترا',['حمام سباحة خاص برئيس مجلس الإدارة — الساحل الشمالي والمقطم']],
  ['pools','نادي مدينة 6 أكتوبر',['حمام السباحة بالإضافة إلى مغطس','إحلال وتجديد الأعمال الميكانيكية والمدنية']],
  ['pools','مدرسة القاهرة الإنجليزية الحديثة — ميراج سيتي',['حمام سباحة أوليمبي']],
  ['pools','فندق أوشن باي كلوب — شرم الشيخ',['حمام السباحة الرئيسي — أعمال التسخين']],
  ['pools','مشروع حياة ريجنسي — شرم الشيخ',['حمامات سباحة ونوافير وشلالات مائية','تركيب وتشغيل']],
  ['pools','فندق نبق — شرم الشيخ',['حمام السباحة الرئيسي']],
  ['pools','المدرسة الأمريكية الدولية — التجمع الخامس',['حمام سباحة (نصف أوليمبي) بجوار أكاديمية الشرطة']],
  ['pools','قرية غناظة (أربيان بيتش) — شرم الشيخ',['شركة صن رايز للاستثمار السياحي','عدد 5 حمامات سباحة','عدد 9 نوافير','عدد 3 شلالات','شبكات المياه: ري وحريق ومياه ساخنة وباردة وتشطيب الصحي الداخلي']],
  ['pools','قرية شارمينج هيلز (مونت ميري) — شرم الشيخ',['عدد 3 حمامات سباحة','عدد 4 نوافير','نوافير وشلالات حمام السباحة لبحيرة الشيزلونجات','شبكات المياه: ري وحريق ومياه ساخنة وباردة وتشطيب صحي']],
  ['pools','قرية الربيع — شرم الشيخ',['نافورة اللاندسكيب','نافورة مدخل القرية','الشبكات الداخلية وأعمال التشطيبات الصحية وشبكات المياه الساخنة والباردة']],
  ['pools','قرية بياسيرا — العين السخنة',['المملوكة لشركة الأهلي للتنمية والاستثمار','عدد 6 حمامات سباحة']],
  ['pools','مدرسة مودرن سكول — القاهرة',['حمام سباحة اسكيمر','ومعهد محمد جلال الأزهري — حمام سباحة']],
  ['pools','بورتو السخنة — شركة عامر جروب',['المرحلة الأولى (الأبراج): عدد 3 حمامات سباحة — مقاول باطن','المرحلة الثانية: عدد 9 حمامات سباحة — مقاول باطن','توريد وتركيب الأعمال الكهروميكانيكية لمعدات حمام سباحة بمنطقة البانوراما','أعمال إلكتروميكانيك لفلتر مياه بحيرة أسفل المركز التجاري — مشروع الأبراج','معالجة الجسم الخارجي ومنع التسرب وتشغيل وتسليم الجواكيز الداخلية والخارجية لوحدات البنت هاوس','توريد وتركيب جريلات الأوفر فلو — جولف بورتو السخنة','توريد وتركيب جريلات الأوفر فلو — جولف بورتو مارينا','توريد وتركيب سلالم حمام السباحة الرئيسي — بورتو كايرو','إعادة تهيئة نوافير المدينة العتيقة بالأسكاي مول','تأسيس وتنفيذ حمامات سباحة متكاملة بوحدة فلترة ومسخنة بفيلات منطقة الهاند 1','أعمال اختبار شبكات بحيرة بورتو مارينا — العلمين','حلول ميكانيكية لحمام سباحة بمنطقة الهاوين — بورتو جولف السخنة','حلول ميكانيكية لحمامي سباحة بالمرحلة الأولى — بورتو ساوث بيتش']],
  ['pools','قرية موسى كوست — رأس سدر',[]],
  ['pools','المدرسة البريطانية الدولية',[]],
  ['pools','مول سيتي ستارز — مدينة نصر',['عدد 7 نوافير']],
  ['pools','ألف ليلة وليلة — شرم الشيخ',['جميع الأعمال المائية الموجودة بها من شلالات ونوافير']],
  ['pools','نادي جزيرة الورد — المنصورة',['النادي الصحي','مغطس','غرفة سونا','حمام سباحة']],
  ['pools','مدرسة بايونيرز للغات — 6 أكتوبر',['عدد 2 حمام سباحة']],
  ['pools','مجموعة فيلات خاصة',['القاهرة الجديدة ومدينة العبور و6 أكتوبر والساحل الشمالي وشرم الشيخ']],
  ['pools','النادي الأهلي — الجزيرة',['تعديلات في غرفة المعدات']],
  ['pools','النادي الأهلي — مدينة نصر',['تعديلات في غرفة المعدات']],
  ['pools','نادي الجزيرة الرياضي',['تعديلات في غرفة المعدات']],
  ['pools','المدرسة الإنجليزية الحديثة — مصر الجديدة',['تعديلات في غرفة المعدات']],
  ['pools','نادي المؤسسة العمالية',['وحدة نظافة متحركة']],
  ['pools','قرية طيبة البشرى — مركز شباب الخطاطبة',['أعمال معالجة مياه وخزانات المياه']],
  ['pools','المبنى الإداري لشركة الأهلي للتنمية العقارية',['تنفيذ أعمال النوافير وإضاءة اللاندسكيب']],
  ['pools','أسكاي مول — بورتو السخنة',['تنفيذ أعمال الإلكتروميكانيك لنوافير المدينة العتيقة']],
  ['pools','متحف دول حوض النيل — أسوان',['الأعمال الإنشائية والإلكتروميكانيكية لنافورة وباثيو المتحف','منفذ من خلال وزارة الموارد المائية والري']],
  ['intl','حمامات سباحة — دولة قطر',[]],
  ['intl','محطات تحلية مياه — السودان',[]],
  ['san','قرية غناظة — شرم الشيخ',['توريد وتركيب الشبكات الخارجية للتغذية والصرف والحريق','الشبكات الداخلية والصحي الداخلي من التأسيس حتى التشطيب لكافة القطاعات: المباني والمطاعم والنادي الصحي']],
  ['san','قرية شارمينج هيلز — شرم الشيخ',['توريد وتركيب الشبكات الخارجية للتغذية والصرف والحريق','الشبكات الداخلية والصحي الداخلي من التأسيس حتى التشطيب لكافة القطاعات']],
  ['san','قرية الربيع — شرم الشيخ',['الشبكات الداخلية والحريق والصحي الداخلي من التأسيس حتى التشطيب لكافة القطاعات']],
  ['san','مشروع كوزموس — التجمع الأول',['المبنى الإداري لشركة السويدي','شبكات الصحي والحريق والنوافير وشبكات الزراعة']],
  ['san','عقارات متعددة — القاهرة والجيزة',['عمليات الإحلال والتجديد لأعمال الصحي الخارجي والداخلي','خزانات المياه وطلمبات الرفع']],
);
my %CATNAME = (pools=>'حمامات سباحة ونوافير', intl=>'أعمال خارج مصر', san=>'صحي وشبكات');

# ============================================================
#  DATA — gallery (order preserved from the original album)
# ============================================================
my @GALLERY = qw(
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

# the company's own list of services, reproduced verbatim from the profile
my @FULLSERVICES = (
  'تصميم حمامات السباحة والنوافير',
  'تصميم كامل وعمل الحسابات الخاصة بمعدات وشبكات حمامات السباحة وتقديم الرسومات الخاصة بها',
  'توريد وتركيب معدات ومستلزمات حمامات السباحة والجاكوزي والهيدروبول',
  'توريد وتركيب الجاكوزي الجاهز',
  'توريد وتركيب النوافير والشلالات',
  'توريد وتركيب غرف السونا',
  'توريد وتركيب غرف البخار',
  'توريد وتركيب محطات معالجة مياه الصرف',
  'توريد وتركيب محطات تنقية مياه الشرب وتحلية مياه البحر',
  'إنشاء وتشطيب وعزل حمامات السباحة',
  'تفريغ وشحن الوسط الترشيحي للفلاتر',
  'توريد وتركيب طلمبات الرفع بجميع أنواعها',
  'القيام بجميع أعمال التركيبات الخاصة بحمامات السباحة ومحطات المياه والشبكات',
  'تصنيع فلاتر وتنكات المياه بجميع أنواعها',
  'تنفيذ كافة الأعمال الخاصة بشبكات المياه بكافة أنواعها من ري وصرف وتغذية وحريق، خارجية وداخلية، تأسيس وتشطيب',
  'أعمال الصيانة الدورية',
);

# ============================================================
#  ICONS
# ============================================================
my %I = (
  phone   => '<path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.13.96.36 1.9.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.9.34 1.85.57 2.81.7A2 2 0 0 1 22 16.92z"/>',
  mail    => '<path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/>',
  pin     => '<path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>',
  clock   => '<circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>',
  check   => '<polyline points="20 6 9 17 4 12"/>',
  arrowl  => '<line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>',
  arrowu  => '<line x1="12" y1="19" x2="12" y2="5"/><polyline points="5 12 12 5 19 12"/>',
  chevd   => '<polyline points="6 9 12 15 18 9"/>',
  chevl   => '<polyline points="15 18 9 12 15 6"/>',
  chevr   => '<polyline points="9 18 15 12 9 6"/>',
  close   => '<line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>',
  play    => '<polygon points="6 3 20 12 6 21 6 3" fill="currentColor" stroke="none"/>',
  zoom    => '<circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/><line x1="11" y1="8" x2="11" y2="14"/><line x1="8" y1="11" x2="14" y2="11"/>',
  dl      => '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/>',
  file    => '<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/>',
  refresh => '<polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/>',
  info    => '<circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/>',
  send    => '<line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/>',
  drop    => '<path d="M12 2.7s6 6.1 6 10.3a6 6 0 0 1-12 0C6 8.8 12 2.7 12 2.7z"/>',
  layers  => '<polygon points="12 2 2 7 12 12 22 7 12 2"/><polyline points="2 17 12 22 22 17"/><polyline points="2 12 12 17 22 12"/>',
  shield  => '<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>',
  wa      => '<path d="M17.5 14.4c-.3-.2-1.7-.9-2-1s-.5-.2-.7.1-.8 1-.9 1.2-.3.2-.6.1a8 8 0 0 1-2.4-1.5 9 9 0 0 1-1.6-2c-.2-.3 0-.5.1-.6l.5-.6a2 2 0 0 0 .3-.5.6.6 0 0 0 0-.5c0-.2-.7-1.6-.9-2.2s-.5-.5-.7-.5h-.6a1.1 1.1 0 0 0-.8.4A3.4 3.4 0 0 0 6 9.3a5.9 5.9 0 0 0 1.2 3.1 13.4 13.4 0 0 0 5.2 4.6c.7.3 1.3.5 1.7.6a4.1 4.1 0 0 0 1.9.1 3.1 3.1 0 0 0 2-1.4 2.5 2.5 0 0 0 .2-1.4c-.1-.2-.3-.3-.6-.4z" fill="currentColor" stroke="none"/><path d="M12 2a10 10 0 0 0-8.6 15L2 22l5.2-1.4A10 10 0 1 0 12 2zm0 18.2a8.2 8.2 0 0 1-4.2-1.1l-.3-.2-3.1.8.8-3-.2-.3A8.2 8.2 0 1 1 12 20.2z"/>',
  fb      => '<path d="M15.5 8.5h-2v-1c0-.6.4-.7.6-.7h1.3V4.6h-1.9c-2.1 0-2.6 1.6-2.6 2.6v1.3H9.6v2.3h1.3V19h2.6v-8.2h1.8z" fill="currentColor" stroke="none"/>',
  ig      => '<rect x="3" y="3" width="18" height="18" rx="5"/><circle cx="12" cy="12" r="4"/><circle cx="17.5" cy="6.5" r="1.1" fill="currentColor" stroke="none"/>',
  tw      => '<path d="M4 4l7 8.5L4.3 20H6l5.8-6.4L16.5 20H20l-7.3-8.9L19.5 4H18l-5.4 6L8.2 4z" fill="currentColor" stroke="none"/>',
  yt      => '<path d="M22 12s0-3-.4-4.4a2.6 2.6 0 0 0-1.8-1.8C18.4 5.4 12 5.4 12 5.4s-6.4 0-7.8.4a2.6 2.6 0 0 0-1.8 1.8C2 9 2 12 2 12s0 3 .4 4.4a2.6 2.6 0 0 0 1.8 1.8c1.4.4 7.8.4 7.8.4s6.4 0 7.8-.4a2.6 2.6 0 0 0 1.8-1.8C22 15 22 12 22 12z"/><polygon points="10.2 15 15 12 10.2 9" fill="currentColor" stroke="none"/>',
  li      => '<rect x="3" y="3" width="18" height="18" rx="3"/><line x1="8" y1="11" x2="8" y2="16"/><circle cx="8" cy="7.8" r="1" fill="currentColor" stroke="none"/><path d="M12 16v-3a2 2 0 0 1 4 0v3"/><line x1="12" y1="11" x2="12" y2="16"/>',
);
# Every icon carries the base class .i so it always has a sane size,
# even where no component rule targets it.
sub ic { my ($k,$cls) = @_; $cls = $cls ? "i $cls" : 'i';
  return qq{<svg class="$cls" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">$I{$k}</svg>}; }

# ============================================================
#  NAV
# ============================================================
my @NAV = (
  ['index.html',    'الرئيسية'],
  ['about.html',    'من نحن'],
  ['services.html', 'الخدمات', 'sub'],
  ['projects.html', 'المشروعات'],
  ['works.html',    'سابقة الأعمال'],
  ['gallery.html',  'ألبوم الصور'],
  ['videos.html',   'الفيديوهات'],
  ['contact.html',  'اتصل بنا'],
);

sub nav_html {
  my ($active) = @_;
  my $o = '<ul class="nav">';
  for my $n (@NAV) {
    my ($href,$label,$sub) = @$n;
    my $on = ($href eq $active) ? ' active' : '';
    $on = ' active' if $sub && $active =~ /^service-/;
    if ($sub) {
      $o .= qq{<li class="has-sub$on"><a href="$href">$label} . ic('chevd','car') . q{</a><ul class="sub">};
      $o .= qq{<li><a href="service-$_->[0].html">$_->[1]</a></li>} for @SERVICES;
      $o .= '</ul></li>';
    } else {
      $o .= qq{<li class="$on"><a href="$href">$label</a></li>};
    }
  }
  return $o . '</ul>';
}

sub drawer_html {
  my ($active) = @_;
  my $o = qq{<div class="drawer" id="drawer"><div class="drawer-top"><img src="assets/img/logo.png" alt="$C{name}"><button class="dclose" aria-label="إغلاق القائمة">} . ic('close') . q{</button></div><ul>};
  for my $n (@NAV) {
    my ($href,$label,$sub) = @$n;
    if ($sub) {
      $o .= qq{<li><div class="drow"><a href="$href" style="flex:1">$label</a><button class="dtoggle" aria-label="عرض الخدمات">} . ic('chevd') . q{</button></div><ul class="sub-m">};
      $o .= qq{<li><a href="service-$_->[0].html">$_->[1]</a></li>} for @SERVICES;
      $o .= '</ul></li>';
    } else {
      $o .= qq{<li><a href="$href">$label</a></li>};
    }
  }
  $o .= q{</ul><div class="drawer-foot">};
  $o .= qq{<a class="btn btn-aqua" href="order.html">اطلب الآن} . ic('arrowl','ic') . q{</a>};
  $o .= qq{<a class="btn btn-ghost" href="tel:$C{mobile}">} . ic('phone','ic') . qq{<span class="tnum">$C{mobile}</span></a>};
  $o .= '</div></div>';
  return $o;
}

# ============================================================
#  SHARED CHUNKS
# ============================================================
sub head_html {
  my ($title,$desc) = @_;
  return <<"HTML";
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$title</title>
<meta name="description" content="$desc">
<meta name="theme-color" content="#04121f">
<meta property="og:type" content="website">
<meta property="og:title" content="$title">
<meta property="og:description" content="$desc">
<meta property="og:image" content="assets/img/a-1.jpg">
<meta property="og:locale" content="ar_EG">
<link rel="icon" href="assets/img/favicon.png" type="image/png">
<link rel="stylesheet" href="assets/css/main.css">
<link rel="stylesheet" href="assets/css/sections.css">
</head>
<body>
<div class="progress"><i></i></div>
HTML
}

sub topbar_html {
  my $soc = qq{<div class="soc">}
    . qq{<a href="$C{fb}" target="_blank" rel="noopener" aria-label="فيسبوك">} . ic('fb') . q{</a>}
    . qq{<a href="$C{ig}" target="_blank" rel="noopener" aria-label="إنستجرام">} . ic('ig') . q{</a>}
    . qq{<a href="$C{tw}" target="_blank" rel="noopener" aria-label="تويتر">} . ic('tw') . q{</a>}
    . qq{<a href="$C{yt}" target="_blank" rel="noopener" aria-label="يوتيوب">} . ic('yt') . q{</a>}
    . qq{<a href="$C{li}" target="_blank" rel="noopener" aria-label="لينكدإن">} . ic('li') . q{</a>}
    . q{</div>};
  return qq{<div class="topline"><div class="wrap"><div class="tl-l">}
    . qq{<span>} . ic('mail') . qq{<a href="mailto:$C{email}">$C{email}</a></span>}
    . qq{<span>} . ic('pin') . qq{$C{addr}</span>}
    . qq{<span>} . ic('clock') . qq{خدمة العملاء على مدار اليوم</span>}
    . qq{</div><div class="tl-r"><span class="tnum"><a href="tel:$C{intl}">+$C{intl}</a></span>$soc</div></div></div>};
}

sub header_html {
  my ($active) = @_;
  return topbar_html()
    . qq{<header class="hdr"><div class="wrap">}
    . qq{<a class="brand" href="index.html"><img src="assets/img/logo.png" alt="$C{full}" width="353" height="108"></a>}
    . nav_html($active)
    . qq{<div class="hdr-cta"><a class="btn btn-aqua" href="order.html">اطلب الآن} . ic('arrowl','ic') . q{</a>}
    . q{<button class="burger" aria-label="القائمة" aria-expanded="false" aria-controls="drawer"><span></span><span></span><span></span></button>}
    . q{</div></div></header>}
    . drawer_html($active);
}

sub footer_html {
  my $links = '';
  $links .= qq{<li><a href="$_->[0]">$_->[1]</a></li>} for @NAV[1..$#NAV];
  $links .= q{<li><a href="order.html">اطلب الآن</a></li>};

  my $svc = '';
  $svc .= qq{<li><a href="service-$_->[0].html">$_->[1]</a></li>} for @SERVICES[0..5];

  return <<"HTML" . fabs_html() . qq{<script src="assets/js/main.js"></script>\n</body>\n</html>\n};
<footer class="footer">
  <div class="caustics" aria-hidden="true"><span></span><span></span><span></span></div>
  <div class="wrap">
    <div class="f-grid">
      <div>
        <img class="flogo" src="assets/img/logo.png" alt="$C{full}">
        <p style="font-size:.94rem;line-height:1.9;max-width:42ch">شركة متخصصة في أعمال المياه: إنشاء وصيانة حمامات السباحة، النوافير والشلالات، محطات التنقية والمعالجة، وشبكات المياه والحريق بجميع أنواعها.</p>
        <div class="f-contact" style="margin-top:1.5em">
          <div>@{[ic('pin')]}<span>$C{addr}</span></div>
          <div>@{[ic('phone')]}<span><a class="tnum" href="tel:$C{mobile}">$C{mobile}</a> — <a class="tnum" href="tel:$C{land}">$C{land}</a></span></div>
          <div>@{[ic('mail')]}<a href="mailto:$C{email}">$C{email}</a></div>
        </div>
      </div>
      <div>
        <h4>روابط الموقع</h4>
        <ul>$links</ul>
      </div>
      <div>
        <h4>خدماتنا</h4>
        <ul>$svc<li><a href="services.html">كل الخدمات</a></li></ul>
        <div class="newsletter">
          <h4 style="margin-top:1.8em">النشرة البريدية</h4>
          <p style="font-size:.9rem;margin-bottom:1em">اشترك لتلقي آخر الأخبار حول خدماتنا ومشروعاتنا.</p>
          <form class="nl-form" novalidate>
            <input type="email" placeholder="أدخل بريدك الإلكتروني" aria-label="البريد الإلكتروني" required>
            <button type="submit">اشترك</button>
          </form>
        </div>
      </div>
    </div>
  </div>
  <div class="f-bottom"><div class="wrap">
    <span>© <span class="yr">2025</span> جميع الحقوق محفوظة — $C{full}</span>
    <a href="assets/doc/AQUAMARINE_CV.pdf" target="_blank" rel="noopener" style="display:inline-flex;gap:.5em;align-items:center">@{[ic('file')]} بروفايل الشركة</a>
  </div></div>
</footer>
HTML
}

sub fabs_html {
  return qq{<div class="fabs">}
    . qq{<a class="fab fab-wa" href="https://api.whatsapp.com/send?phone=$C{wa}" target="_blank" rel="noopener" aria-label="واتساب">} . ic('wa') . q{</a>}
    . qq{<a class="fab fab-tel" href="tel:$C{mobile}" aria-label="اتصل بنا">} . ic('phone') . q{</a>}
    . qq{<button class="fab fab-top" aria-label="أعلى الصفحة">} . ic('arrowu') . q{</button>}
    . q{</div>};
}

# page hero for inner pages
sub phero {
  my ($title,$lead,$img,$crumbs) = @_;
  my $c = q{<nav class="crumb"><a href="index.html">الرئيسية</a>};
  for my $b (@$crumbs) {
    $c .= q{<i>/</i>};
    $c .= $b->[1] ? qq{<a href="$b->[1]">$b->[0]</a>} : qq{<span class="cur">$b->[0]</span>};
  }
  $c .= '</nav>';
  my $l = $lead ? qq{<p class="lead">$lead</p>} : '';
  return qq{<section class="phero grain"><div class="bgi" style="background-image:url('assets/img/$img')"></div><div class="caustics" aria-hidden="true"><span></span><span></span></div><div class="wrap"><h1 class="h1">$title</h1>$l$c</div></section><hr class="waterline">};
}

# reusable CTA band
sub cta_band {
  return <<"HTML";
<section class="cta grain">
  <div class="bgi" style="background-image:url('assets/img/a-4.jpg')"></div>
  <div class="wrap">
    <div class="cta-in">
      <div class="t">
        <span class="eyebrow" style="color:#7ce9fb">/ GET IN TOUCH</span>
        <h2 class="h2" style="margin-top:1rem">اتصل بشركة أكوا مارين ووتر سيستمز</h2>
        <p class="lead" style="color:#b9d5e6">فريقنا متاح على مدار اليوم للإجابة على جميع استفساراتك وتقديم عرض السعر المناسب لمشروعك.</p>
      </div>
      <div style="display:grid;gap:16px;justify-items:start">
        <a class="cta-tel tnum" href="tel:$C{mobile}">@{[ic('phone')]} $C{mobile}</a>
        <div style="display:flex;gap:12px;flex-wrap:wrap">
          <a class="btn btn-aqua" href="order.html">اطلب الآن @{[ic('arrowl','ic')]}</a>
          <a class="btn btn-ghost" href="https://api.whatsapp.com/send?phone=$C{wa}" target="_blank" rel="noopener">@{[ic('wa','ic')]} واتساب</a>
        </div>
      </div>
    </div>
  </div>
</section>
HTML
}

sub wave {
  my ($from,$to) = @_;   # colours
  return qq{<div class="wave" style="background:$from"><svg viewBox="0 0 1440 90" preserveAspectRatio="none"><path fill="$to" d="M0,40 C240,90 420,0 720,34 C1020,68 1200,86 1440,42 L1440,90 L0,90 Z"/></svg></div>};
}

# services list block (the company's own verbatim list)
sub fullservices_ul {
  my ($cls) = @_;
  my $li = join '', map { "<li>$_</li>" } @FULLSERVICES;
  $cls = $cls ? qq{ class="$cls"} : '';
  return qq{<ul$cls>$li</ul>};
}
sub fullservices_block {
  return q{<h2>خدمات شركة أكوا مارين</h2>} . fullservices_ul();
}
# full services nav list (used in detail-page sidebars)
sub svclist_all {
  my ($current) = @_;
  my $o = '<ul class="svc-list">';
  for my $s (@SERVICES) {
    my $on = ($current && $s->[0] eq $current) ? ' class="on"' : '';
    $o .= qq{<li$on><a href="service-$s->[0].html">$s->[1]} . ic('arrowl','ic') . '</a></li>';
  }
  return $o . '</ul>';
}

sub svc_cards {
  my ($limit) = @_;
  my $o = '<div class="svc-grid">';
  my $n = 0;
  for my $s (@SERVICES) {
    last if $limit && $n >= $limit;
    my $d = sprintf('%.2f', ($n % 3) * 0.09);
    $o .= qq{<article class="svc" data-rv data-delay="$d">}
       . qq{<div class="svc-img"><img src="assets/img/$s->[3]" alt="$s->[1]" loading="lazy"><span class="numeral">$AI[$n]</span></div>}
       . qq{<div class="svc-body"><h3>$s->[1]</h3><p>$s->[2]</p>}
       . qq{<a class="tlink" href="service-$s->[0].html">تفاصيل الخدمة} . ic('arrowl','ic') . q{</a></div></article>};
    $n++;
  }
  return $o . '</div>';
}

sub proj_cards {
  my ($skip) = @_;
  my $o = '<div class="proj-grid">';
  my $n = 0;
  for my $p (@PROJECTS) {
    next if $skip && $p->[0] eq $skip;
    my $d = sprintf('%.2f', ($n % 3) * 0.09);
    $o .= qq{<a class="proj" href="project-$p->[0].html" data-rv data-delay="$d">}
       . qq{<img src="assets/img/$p->[4]" alt="$p->[1]" loading="lazy">}
       . qq{<div class="proj-in"><span class="tag">$p->[2]</span><h3>$p->[1]</h3><p>$p->[3]</p>}
       . qq{<span class="go">عرض المشروع } . ic('arrowl','ic') . q{</span></div></a>};
    $n++;
  }
  return $o . '</div>';
}

# ============================================================
#  WRITER
# ============================================================
sub page {
  my ($file,$title,$desc,$active,$body) = @_;
  open(my $fh, '>:encoding(UTF-8)', "$OUT/$file") or die "$file: $!";
  print $fh head_html($title,$desc), header_html($active), $body, footer_html();
  close $fh;
  print "  wrote $file\n";
}

print "Building Aqua Marine site...\n";

# ============================================================
#  HOME
# ============================================================
{
# Only the first slide is fetched up front; the rest are attached after
# window load (the second slide isn't shown until 8s in).
my $slides = qq{<i style="background-image:url('assets/img/a-1.jpg')"></i>}
           . join '', map { qq{<i data-bg="assets/img/a-$_.jpg"></i>} } (2..4);

my $body = <<"HTML";
<section class="hero grain">
  <div class="hero-bg" aria-hidden="true">$slides</div>
  <div class="hero-scrim" aria-hidden="true"></div>
  <div class="caustics" aria-hidden="true"><span></span><span></span><span></span></div>
  <div class="wrap">
    <div class="hero-in">
      <span class="eyebrow">/ AQUA MARINE WATER SYSTEMS</span>
      <h1 class="display">نبني الماء<br><b>كما يجب أن يكون</b></h1>
      <p class="lead">شركة متخصصة في أعمال المياه: إنشاء وصيانة حمامات السباحة الخاصة والعامة وحمامات النوادي الرياضية، وشبكات مياه الشرب والصرف والري والحريق، ومحطات التنقية والمعالجة.</p>
      <div class="hero-btns">
        <a class="btn btn-aqua btn-lg" href="services.html">تصفح خدماتنا @{[ic('arrowl','ic')]}</a>
        <a class="btn btn-ghost btn-lg" href="works.html">سابقة الأعمال</a>
      </div>
    </div>
  </div>
  <span class="scroll-cue">SCROLL</span>
  <div class="hero-bar">
    <div class="wrap" style="width:min(1240px,100% - var(--gut)*2)">
      <ul>
        <li><b class="tnum">33</b><span>مشروعاً في سابقة الأعمال</span></li>
        <li><b class="tnum">09</b><span>خدمات متخصصة</span></li>
        <li><b class="tnum">03</b><span>دول: مصر وقطر والسودان</span></li>
        <li><b class="tnum">24/7</b><span>خدمة عملاء ودعم فني</span></li>
      </ul>
    </div>
  </div>
</section>

<section class="section">
  <div class="wrap">
    <div class="split">
      <div class="split-media" data-rv="s">
        <div class="m1"><img src="assets/img/about.jpg" alt="من أعمال أكوا مارين ووتر سيستمز" loading="lazy"></div>
        <div class="m2"><img src="assets/img/aquamarine16.jpg" alt="حمام سباحة من تنفيذ الشركة" loading="lazy"></div>
        <div class="badge-yrs"><b class="tnum">33</b><span>مشروعاً مرجعياً<br>داخل مصر وخارجها</span></div>
      </div>
      <div data-rv>
        <span class="eyebrow">/ ABOUT US</span>
        <h2 class="h2" style="margin:1.1rem 0 1rem">مرحباً بكم في شركة أكوا مارين ووتر سيستمز</h2>
        <p class="lead">نحن شركة تعمل في مجال المياه بصفة عامة، متخصصون في أعمال إنشاء وصيانة حمامات السباحة الخاصة والعامة وحمامات سباحة النوادي الرياضية.</p>
        <ul class="ticks">
          <li>@{[ic('check')]}<span>أعمال شبكات مياه الشرب والصرف الصحي والري والحريق والمياه الساخنة للغرف الفندقية بجميع أنواعها — UPVC و PPR و HDPE.</span></li>
          <li>@{[ic('check')]}<span>إنشاء شبكات مكافحة الحريق الداخلية وأعمال الصحي الداخلي (السباكة الداخلية).</span></li>
          <li>@{[ic('check')]}<span>تصميم كامل وعمل الحسابات الخاصة بمعدات وشبكات حمامات السباحة وتقديم الرسومات الخاصة بها.</span></li>
          <li>@{[ic('check')]}<span>أعمال الصيانة الدورية لحمامات السباحة ومحطات التحلية.</span></li>
        </ul>
        <div style="display:flex;gap:13px;flex-wrap:wrap">
          <a class="btn" href="about.html">تعرّف علينا أكثر @{[ic('arrowl','ic')]}</a>
          <a class="btn btn-ghost" href="assets/doc/AQUAMARINE_CV.pdf" target="_blank" rel="noopener">@{[ic('dl','ic')]} بروفايل الشركة</a>
        </div>
      </div>
    </div>
  </div>
</section>

<section class="section" style="background:var(--paper-2)">
  <div class="wrap">
    <div class="sec-head">
      <div class="t" data-rv>
        <span class="eyebrow">/ OUR SERVICES</span>
        <h2 class="h2" style="margin-top:1rem">خدمات متكاملة تحت سقف واحد</h2>
        <p class="lead" style="margin-top:.7rem">من التصميم والحسابات الهندسية حتى التنفيذ والتشغيل والصيانة الدورية.</p>
      </div>
      <a class="btn btn-ghost" href="services.html" data-rv>كل الخدمات @{[ic('arrowl','ic')]}</a>
    </div>
    @{[svc_cards(6)]}
  </div>
</section>

@{[cta_band()]}

<section class="section dark grain" style="background:var(--deep)">
  <div class="caustics" aria-hidden="true"><span></span><span></span></div>
  <div class="wrap">
    <div class="sec-head">
      <div class="t" data-rv>
        <span class="eyebrow">/ SELECTED PROJECTS</span>
        <h2 class="h2" style="margin-top:1rem">مشروعات نفخر بتنفيذها</h2>
        <p class="lead" style="margin-top:.7rem">منتجعات وفنادق ومدارس وأندية ومنشآت صناعية في مصر والخليج.</p>
      </div>
      <a class="btn btn-ghost" href="projects.html" data-rv>كل المشروعات @{[ic('arrowl','ic')]}</a>
    </div>
    @{[proj_cards()]}

    <div class="stats" style="margin-top:clamp(38px,5vw,64px)" data-rv>
      <div class="stat"><b class="tnum"><span data-count="33">0</span><em>+</em></b><span>مشروعاً في سابقة الأعمال</span></div>
      <div class="stat"><b class="tnum"><span data-count="50">0</span><em>+</em></b><span>حمام سباحة ونافورة</span></div>
      <div class="stat"><b class="tnum"><span data-count="9">0</span></b><span>خدمات هندسية متخصصة</span></div>
      <div class="stat"><b class="tnum"><span data-count="3">0</span></b><span>دول عمل</span></div>
    </div>
  </div>
</section>

<section class="section">
  <div class="wrap">
    <div class="sec-head">
      <div class="t" data-rv>
        <span class="eyebrow">/ GALLERY</span>
        <h2 class="h2" style="margin-top:1rem">ألبوم الصور</h2>
        <p class="lead" style="margin-top:.7rem">معرض لمجموعة من أميز أعمالنا الإبداعية.</p>
      </div>
      <a class="btn btn-ghost" href="gallery.html" data-rv>كل الصور @{[ic('arrowl','ic')]}</a>
    </div>
    @{[gal_html(12)]}
  </div>
</section>

<section class="section abyss grain" style="background:var(--abyss)">
  <div class="caustics" aria-hidden="true"><span></span><span></span></div>
  <div class="wrap-n" style="text-align:center">
    <span class="eyebrow" style="color:#7ce9fb" data-rv>/ WATCH</span>
    <h2 class="h2" style="margin:1rem 0 .8rem;color:#fff" data-rv>شاهد أكوا مارين في العمل</h2>
    <p class="lead" style="margin-bottom:2.4rem;color:#a8c6da" data-rv>جولة قصيرة داخل بعض مشروعاتنا المنفذة.</p>
    @{[video_html()]}
  </div>
</section>
HTML
page('index.html', "$C{full} — حمامات سباحة ومحطات مياه ونوافير", 'شركة أكوا مارين ووتر سيستمز: تصميم وإنشاء وصيانة حمامات السباحة، النوافير والشلالات، محطات تنقية مياه الشرب ومعالجة الصرف، غرف السونا والبخار، وشبكات المياه والحريق.', 'index.html', $body);
}

# gallery markup
sub gal_html {
  my ($limit) = @_;
  my @g = $limit ? @GALLERY[0..$limit-1] : @GALLERY;
  my $o = '<div class="gal">';
  my $n = 0;
  for my $g (@g) {
    my $d = sprintf('%.2f', ($n % 4) * 0.07);
    $o .= qq{<figure data-full="assets/img/$g" data-cap="أكوا مارين ووتر سيستمز" data-rv data-delay="$d" aria-label="تكبير الصورة">}
       . qq{<img src="assets/img/$g" alt="من أعمال أكوا مارين ووتر سيستمز" loading="lazy">}
       . qq{<figcaption>} . ic('zoom') . q{ تكبير الصورة</figcaption></figure>};
    $n++;
  }
  return $o . '</div>' . lb_html();
}

sub lb_html {
  return qq{<div class="lb" aria-hidden="true" role="dialog" aria-label="معرض الصور">}
    . qq{<div class="lb-bar"><span class="lb-count tnum">1 / 1</span><button class="lb-btn lb-close" aria-label="إغلاق">} . ic('close') . q{</button></div>}
    . qq{<button class="lb-btn lb-nav lb-prev" aria-label="السابق">} . ic('chevr') . q{</button>}
    . q{<img src="" alt="">}
    . qq{<button class="lb-btn lb-nav lb-next" aria-label="التالي">} . ic('chevl') . q{</button>}
    . q{</div>};
}

sub video_html {
  return qq{<div class="vid" data-yt="$C{ytid}" data-title="أكوا مارين ووتر سيستمز" data-rv="s">}
    . qq{<button class="vid-poster" aria-label="تشغيل الفيديو"><img src="assets/img/a-3.jpg" alt="فيديو أكوا مارين ووتر سيستمز">}
    . qq{<span class="play">} . ic('play') . q{</span></button></div>};
}

# ============================================================
#  ABOUT
# ============================================================
{
my $body = phero('من نحن','شركة تعمل في مجال المياه بصفة عامة — تصميماً وتنفيذاً وصيانة.','about.jpg',[['من نحن']])
. <<"HTML";
<section class="section">
  <div class="wrap">
    <div class="split">
      <div data-rv>
        <span class="eyebrow">/ WHO WE ARE</span>
        <h2 class="h2" style="margin:1.1rem 0 1rem">مرحباً بكم في شركة أكوا مارين ووتر سيستمز</h2>
        <p class="lead">نحن شركة تعمل في مجال المياه بصفة عامة.</p>
        <ul class="ticks">
          <li>@{[ic('check')]}<span>متخصصون في أعمال إنشاء وصيانة حمامات السباحة الخاصة والعامة وحمامات سباحة النوادي الرياضية.</span></li>
          <li>@{[ic('check')]}<span>متخصصون في أعمال شبكات مياه الشرب ومياه الصرف الصحي ومياه الري ومياه الحريق والمياه الساخنة للغرف الفندقية بجميع أنواعها — UPVC و PPR و HDPE.</span></li>
          <li>@{[ic('check')]}<span>متخصصون في إنشاء شبكات مكافحة الحريق الداخلية.</span></li>
          <li>@{[ic('check')]}<span>أعمال الصحي الداخلي (السباكة الداخلية).</span></li>
        </ul>
        <div class="pill-row">
          <span class="pill">UPVC</span><span class="pill">PPR</span><span class="pill">HDPE</span>
          <span class="pill">تصميم وحسابات</span><span class="pill">تنفيذ وتشغيل</span><span class="pill">صيانة دورية</span>
        </div>
      </div>
      <div class="split-media" data-rv="s">
        <div class="m1"><img src="assets/img/aquamarine26(1).jpg" alt="من أعمال الشركة" loading="lazy"></div>
        <div class="m2"><img src="assets/img/aquamarine1(1).jpeg" alt="نوافير وشلالات" loading="lazy"></div>
      </div>
    </div>
  </div>
</section>

<section class="section" style="background:var(--paper-2);padding-top:0">
  @{[wave('var(--paper)','var(--paper-2)')]}
  <div class="wrap" style="padding-top:clamp(48px,6vw,84px)">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ WHAT WE DO</span>
      <h2 class="h2" style="margin-top:1rem">خدمات شركة أكوا مارين ووتر سيستمز</h2>
    </div></div>
    <div class="prose" data-rv>
      @{[fullservices_ul('cols2')]}
    </div>
    <div style="margin-top:clamp(32px,4vw,52px);display:flex;gap:13px;flex-wrap:wrap" data-rv>
      <a class="btn" href="services.html">تفاصيل كل خدمة @{[ic('arrowl','ic')]}</a>
      <a class="btn btn-ghost" href="works.html">سابقة الأعمال</a>
    </div>
  </div>
</section>

<section class="section dark grain">
  <div class="caustics" aria-hidden="true"><span></span><span></span></div>
  <div class="wrap">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ TRACK RECORD</span>
      <h2 class="h2" style="margin-top:1rem">أرقام تختصر خبرتنا</h2>
    </div></div>
    <div class="stats" data-rv>
      <div class="stat"><b class="tnum"><span data-count="33">0</span><em>+</em></b><span>مشروعاً في سابقة الأعمال</span></div>
      <div class="stat"><b class="tnum"><span data-count="50">0</span><em>+</em></b><span>حمام سباحة ونافورة</span></div>
      <div class="stat"><b class="tnum"><span data-count="9">0</span></b><span>خدمات هندسية متخصصة</span></div>
      <div class="stat"><b class="tnum"><span data-count="3">0</span></b><span>دول عمل: مصر وقطر والسودان</span></div>
    </div>
    <div style="margin-top:clamp(32px,4vw,52px);max-width:560px" data-rv>
      <a class="dl" href="assets/doc/AQUAMARINE_CV.pdf" target="_blank" rel="noopener" style="background:rgba(255,255,255,.05);border-color:rgba(124,233,251,.2)">
        <span class="ico">@{[ic('file')]}</span>
        <span style="flex:1"><b style="color:#fff">بروفايل الشركة الكامل</b><span style="color:#8fb3c9">ملف PDF — سابقة الأعمال والخدمات التفصيلية</span></span>
        @{[ic('dl')]}
      </a>
    </div>
  </div>
</section>

@{[cta_band()]}
HTML
page('about.html', "من نحن — $C{full}", 'تعرف على شركة أكوا مارين ووتر سيستمز: التخصصات والخدمات وسابقة الأعمال في مجال حمامات السباحة وشبكات ومحطات المياه.', 'about.html', $body);
}

# ============================================================
#  SERVICES (listing)
# ============================================================
{
my $body = phero('الخدمات','من التصميم والحسابات الهندسية حتى التنفيذ والتشغيل والصيانة الدورية.','aquamarine16(1).jpg',[['الخدمات']])
. <<"HTML";
<section class="section">
  <div class="wrap">
    @{[svc_cards()]}
  </div>
</section>

<section class="section" style="background:var(--paper-2);padding-top:0">
  @{[wave('var(--paper)','var(--paper-2)')]}
  <div class="wrap-n" style="padding-top:clamp(48px,6vw,84px)">
    <div class="prose" data-rv>
      <p class="lead">توريد جميع معدات ومستلزمات حمامات السباحة ومحطات المعالجة والوسط الترشيحي للفلاتر وطلمبات الرفع بجميع أنواعها، والقيام بجميع أعمال التركيبات الخاصة بحمامات السباحة ومحطات المياه والشبكات وتصنيع فلاتر وتنكات المياه، كما تقوم الشركة بأعمال الصيانة الدورية لحمامات السباحة ومحطات التحلية.</p>
      @{[fullservices_block()]}
    </div>
  </div>
</section>

@{[cta_band()]}
HTML
page('services.html', "الخدمات — $C{full}", 'خدمات أكوا مارين: تصميم وإنشاء حمامات السباحة، النوافير والشلالات، محطات تنقية ومعالجة المياه، طلمبات الرفع، غرف السونا والبخار، وشبكات المياه.', 'services.html', $body);
}

# ============================================================
#  SERVICE DETAIL PAGES
# ============================================================
{
my $i = 0;
for my $s (@SERVICES) {
  my ($slug,$title,$blurb,$img) = @$s;
  my $side = svclist_all($slug);

  my $extra = ($slug eq 'steam-rooms')
    ? qq{<div class="grid g-2" style="margin-top:2.2rem"><img src="assets/img/20080119(002).jpg" alt="غرف البخار" loading="lazy" style="border-radius:var(--rad);width:100%"><img src="assets/img/$img" alt="غرف البخار" loading="lazy" style="border-radius:var(--rad);width:100%"></div>}
    : '';

  my $body = phero($title,$blurb,$img,[['الخدمات','services.html'],[$title]])
  . <<"HTML";
<section class="section">
  <div class="wrap">
    <div class="grid" style="grid-template-columns:1fr 340px;align-items:start;gap:clamp(30px,4vw,60px)">
      <div class="prose" data-rv>
        <p class="lead">$blurb</p>
        <p>توريد جميع معدات ومستلزمات حمامات السباحة ومحطات المعالجة والوسط الترشيحي للفلاتر وطلمبات الرفع بجميع أنواعها، والقيام بجميع أعمال التركيبات الخاصة بحمامات السباحة ومحطات المياه والشبكات وتصنيع فلاتر وتنكات المياه، كما تقوم الشركة بأعمال الصيانة الدورية لحمامات السباحة ومحطات التحلية.</p>
        $extra
        @{[fullservices_block()]}
        <div class="note">@{[ic('info')]} للحصول على عرض سعر لهذه الخدمة، يمكنك <a href="order.html" style="color:var(--aqua-dim);font-weight:500">تسجيل طلبك</a> أو الاتصال على <a class="tnum" href="tel:$C{mobile}" style="color:var(--aqua-dim);font-weight:500">$C{mobile}</a>.</div>
      </div>
      <aside data-rv style="position:sticky;top:100px">
        <h3 class="h3" style="margin-bottom:1.1rem">كل الخدمات</h3>
        $side
        <a class="btn btn-aqua" href="order.html" style="width:100%;justify-content:center;margin-top:1.2rem">اطلب هذه الخدمة @{[ic('arrowl','ic')]}</a>
        <a class="dl" href="assets/doc/AQUAMARINE_CV.pdf" target="_blank" rel="noopener" style="margin-top:12px">
          <span class="ico">@{[ic('file')]}</span>
          <span style="flex:1"><b>بروفايل الشركة</b><span>PDF</span></span>@{[ic('dl')]}
        </a>
      </aside>
    </div>
  </div>
</section>

<section class="section dark grain" style="padding-top:clamp(48px,6vw,84px)">
  <div class="caustics" aria-hidden="true"><span></span><span></span></div>
  <div class="wrap">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ PROJECTS</span>
      <h2 class="h2" style="margin-top:1rem">من مشروعاتنا</h2>
    </div><a class="btn btn-ghost" href="projects.html" data-rv>كل المشروعات @{[ic('arrowl','ic')]}</a></div>
    @{[proj_cards()]}
  </div>
</section>

@{[cta_band()]}
HTML
  page("service-$slug.html", "$title — $C{full}", $blurb, 'services.html', $body);
  $i++;
}
}

# ============================================================
#  PROJECTS (listing)
# ============================================================
{
my $body = phero('المشروعات','منتجعات وفنادق ومدارس وأندية ومنشآت صناعية في مصر والخليج.','aquamarine25(1).jpg',[['المشروعات']])
. <<"HTML";
<section class="section">
  <div class="wrap">@{[proj_cards()]}</div>
</section>

<section class="section" style="background:var(--paper-2);padding-top:0">
  @{[wave('var(--paper)','var(--paper-2)')]}
  <div class="wrap" style="padding-top:clamp(48px,6vw,84px)">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ FULL RECORD</span>
      <h2 class="h2" style="margin-top:1rem">سابقة أعمال كاملة</h2>
      <p class="lead" style="margin-top:.7rem">قائمة تفصيلية بأعمال الشركة في حمامات السباحة والنوافير والشلالات والنوادي الصحية والأعمال الصحية وشبكات الري والصرف والحريق.</p>
    </div><a class="btn" href="works.html" data-rv>استعرض القائمة @{[ic('arrowl','ic')]}</a></div>
  </div>
</section>

@{[cta_band()]}
HTML
page('projects.html', "المشروعات — $C{full}", 'مشروعات أكوا مارين ووتر سيستمز: بورتو السخنة، ألف ليلة وليلة شرم الشيخ، كونتننتال الغردقة، مدرسة القاهرة الإنجليزية الحديثة وغيرها.', 'projects.html', $body);
}

# ============================================================
#  PROJECT DETAIL PAGES
# ============================================================
{
for my $p (@PROJECTS) {
  my ($slug,$title,$tag,$blurb,$img) = @$p;
  my $body = phero($title,$blurb,$img,[['المشروعات','projects.html'],[$title]])
  . <<"HTML";
<section class="section">
  <div class="wrap">
    <div class="grid" style="grid-template-columns:1fr 340px;align-items:start;gap:clamp(30px,4vw,60px)">
      <div class="prose" data-rv>
        <span class="eyebrow">/ $tag</span>
        <p class="lead" style="margin-top:1rem">$blurb</p>
        <img src="assets/img/$img" alt="$title" loading="lazy" style="border-radius:var(--rad-lg);width:100%;margin:1.8rem 0">
        @{[fullservices_block()]}
      </div>
      <aside data-rv style="position:sticky;top:100px">
        <h3 class="h3" style="margin-bottom:1.1rem">خدماتنا</h3>
        @{[svclist_all()]}
        <a class="btn btn-aqua" href="order.html" style="width:100%;justify-content:center;margin-top:1.2rem">اطلب الآن @{[ic('arrowl','ic')]}</a>
      </aside>
    </div>
  </div>
</section>

<section class="section dark grain" style="padding-top:clamp(48px,6vw,84px)">
  <div class="caustics" aria-hidden="true"><span></span><span></span></div>
  <div class="wrap">
    <div class="sec-head"><div class="t" data-rv>
      <span class="eyebrow">/ MORE</span>
      <h2 class="h2" style="margin-top:1rem">مشروعات أخرى</h2>
    </div></div>
    @{[proj_cards($slug)]}
  </div>
</section>

@{[cta_band()]}
HTML
  page("project-$slug.html", "$title — $C{full}", $blurb, 'projects.html', $body);
}
}

# ============================================================
#  WORKS LEDGER
# ============================================================
{
my $rows = '';
my $n = 0;
for my $w (@WORKS) {
  my ($cat,$title,$det) = @$w;
  $n++;
  my $num = sprintf('%02d', $n);
  my $sub = '';
  if (@$det == 1) { $sub = "<small>$det->[0]</small>"; }
  elsif (@$det > 1) { $sub = '<ul>' . join('', map { "<li>$_</li>" } @$det) . '</ul>'; }
  $rows .= qq{<div class="lrow" data-cat="$cat"><span class="n tnum">$num</span><div class="t">$title$sub</div><span class="k">$CATNAME{$cat}</span></div>};
}

my $body = phero('سابقة الأعمال','قائمة تفصيلية بمشروعات الشركة داخل جمهورية مصر العربية وخارجها.','aquamarine22(1).jpg',[['سابقة الأعمال']])
. <<"HTML";
<section class="section">
  <div class="wrap">
    <div class="sec-head" style="margin-bottom:clamp(22px,2.6vw,32px)"><div class="t" data-rv>
      <span class="eyebrow">/ TRACK RECORD</span>
      <h2 class="h2" style="margin-top:1rem">أعمال منفذة</h2>
      <p class="lead" style="margin-top:.7rem">هذا علاوة على إمكانية إنشاء كافة أنواع حمامات السباحة من أعمال مدنية وتشطيبات وأعمال كهروميكانيكية، والقيام بكافة الأعمال الصحية الداخلية والخارجية وأعمال شبكات مكافحة الحريق.</p>
    </div></div>

    <div class="chips" data-rv>
      <button class="chip on" data-filter="all">الكل</button>
      <button class="chip" data-filter="pools">حمامات سباحة ونوافير</button>
      <button class="chip" data-filter="san">صحي وشبكات</button>
      <button class="chip" data-filter="intl">أعمال خارج مصر</button>
    </div>

    <div class="ledger" data-rv>$rows</div>
  </div>
</section>

@{[cta_band()]}
HTML
page('works.html', "سابقة الأعمال — $C{full}", 'سابقة أعمال شركة أكوا مارين ووتر سيستمز في حمامات السباحة والنوافير والشلالات والنوادي الصحية وشبكات الري والصرف والحريق داخل مصر وخارجها.', 'works.html', $body);
}

# ============================================================
#  GALLERY
# ============================================================
{
my $body = phero('ألبوم الصور','معرض لمجموعة من أميز أعمالنا الإبداعية.','aquamarine20.jpg',[['ألبوم الصور']])
. qq{<section class="section"><div class="wrap">@{[gal_html()]}</div></section>}
. cta_band();
page('gallery.html', "ألبوم الصور — $C{full}", 'معرض صور أعمال شركة أكوا مارين ووتر سيستمز: حمامات السباحة والنوافير والشلالات ومحطات المياه.', 'gallery.html', $body);
}

# ============================================================
#  VIDEOS
# ============================================================
{
my $body = phero('الفيديوهات','جولة داخل بعض مشروعات أكوا مارين ووتر سيستمز.','a-3.jpg',[['الفيديوهات']])
. <<"HTML";
<section class="section">
  <div class="wrap-n">
    @{[video_html()]}
    <div style="margin-top:2rem;display:flex;align-items:center;justify-content:space-between;gap:20px;flex-wrap:wrap" data-rv>
      <div>
        <h2 class="h3">أكوا مارين ووتر سيستمز</h2>
        <p class="muted" style="font-size:.92rem;margin-top:.3em">فيديو تعريفي بأعمال الشركة</p>
      </div>
      <a class="btn btn-ghost" href="$C{yt}" target="_blank" rel="noopener">@{[ic('yt','ic')]} مشاهدة على يوتيوب</a>
    </div>
  </div>
</section>

@{[cta_band()]}
HTML
page('videos.html', "الفيديوهات — $C{full}", 'فيديوهات أعمال شركة أكوا مارين ووتر سيستمز.', 'videos.html', $body);
}

# ============================================================
#  CONTACT
# ============================================================
{
my $body = phero('اتصل بنا','فريقنا متاح على مدار اليوم للإجابة على جميع استفساراتك.','aquamarine23(1).jpg',[['اتصل بنا']])
. <<"HTML";
<section class="section">
  <div class="wrap">
    <div class="ccards">
      <div class="ccard" data-rv><span class="ico">@{[ic('pin')]}</span><h3>العنوان</h3><p>$C{addr}</p></div>
      <div class="ccard" data-rv data-delay="0.09"><span class="ico">@{[ic('phone')]}</span><h3>الهاتف</h3>
        <a class="tnum" href="tel:$C{mobile}">$C{mobile}</a>
        <a class="tnum" href="tel:$C{mobile2}">$C{mobile2}</a>
        <a class="tnum" href="tel:$C{land}">$C{land}</a>
        <a class="tnum" href="tel:$C{intl}">+$C{intl}</a>
      </div>
      <div class="ccard" data-rv data-delay="0.18"><span class="ico">@{[ic('mail')]}</span><h3>البريد الإلكتروني</h3>
        <a href="mailto:$C{email}">$C{email}</a>
        <p style="margin-top:.5em">خدمة العملاء على مدار اليوم</p>
      </div>
    </div>
  </div>
</section>

<section class="section" style="background:var(--paper-2);padding-top:0">
  @{[wave('var(--paper)','var(--paper-2)')]}
  <div class="wrap" style="padding-top:clamp(48px,6vw,84px)">
    <div class="grid" style="grid-template-columns:1.15fr .85fr;gap:clamp(28px,3.5vw,52px);align-items:start">
      <div class="formcard" data-rv>
        <span class="eyebrow">/ SEND A MESSAGE</span>
        <h2 class="h2" style="margin:1rem 0 1.6rem">تواصل معنا</h2>
        <form data-validate data-wa="$C{wa}" data-subject="رسالة من نموذج (اتصل بنا)" novalidate>
          @{[form_msg()]}
          <div class="fgrid">
            <div class="field"><label for="c-name">الاسم <i>*</i></label><input id="c-name" name="name" type="text" placeholder="الاسم بالكامل" required><span class="err">من فضلك أدخل الاسم</span></div>
            <div class="field"><label for="c-phone">الموبايل <i>*</i></label><input id="c-phone" name="phone" type="tel" inputmode="tel" placeholder="01xxxxxxxxx" required><span class="err">من فضلك أدخل رقم الموبايل</span></div>
            <div class="field full"><label for="c-email">البريد الإلكتروني <i>*</i></label><input id="c-email" name="email" type="email" placeholder="name\@example.com" required><span class="err">من فضلك أدخل بريداً صحيحاً</span></div>
            <div class="field full"><label for="c-msg">الرسالة <i>*</i></label><textarea id="c-msg" name="message" placeholder="اكتب استفسارك أو تفاصيل مشروعك..." required></textarea><span class="err">من فضلك اكتب رسالتك</span></div>
            @{[captcha()]}
          </div>
          <button class="btn btn-aqua btn-lg" type="submit" style="margin-top:1.5rem">@{[ic('send','ic')]} إرسال الرسالة</button>
          @{[form_note()]}
        </form>
      </div>
      <div data-rv data-delay="0.1">
        <h3 class="h3" style="margin-bottom:1.1rem">موقعنا على الخريطة</h3>
        <iframe class="map" src="$C{map}" loading="lazy" referrerpolicy="no-referrer-when-downgrade" title="موقع شركة أكوا مارين على الخريطة" allowfullscreen></iframe>
        <div style="display:grid;gap:12px;margin-top:18px">
          <a class="btn btn-aqua" href="https://api.whatsapp.com/send?phone=$C{wa}" target="_blank" rel="noopener" style="justify-content:center">@{[ic('wa','ic')]} تواصل عبر واتساب</a>
          <a class="btn btn-ghost" href="tel:$C{mobile}" style="justify-content:center">@{[ic('phone','ic')]} <span class="tnum">$C{mobile}</span></a>
        </div>
      </div>
    </div>
  </div>
</section>
HTML
page('contact.html', "اتصل بنا — $C{full}", 'تواصل مع شركة أكوا مارين ووتر سيستمز: العنوان وأرقام الهاتف والبريد الإلكتروني ونموذج المراسلة.', 'contact.html', $body);
}

# ============================================================
#  ORDER
# ============================================================
{
my $opts = join '', map { qq{<option value="$_->[1]">$_->[1]</option>} } @SERVICES;
my $body = phero('اطلب الآن','سجّل طلبك وسيتواصل معك فريقنا في أقرب وقت.','aquamarine26(1).jpg',[['اطلب الآن']])
. <<"HTML";
<section class="section">
  <div class="wrap">
    <div class="grid" style="grid-template-columns:1.15fr .85fr;gap:clamp(28px,3.5vw,52px);align-items:start">
      <div class="formcard" data-rv>
        <span class="eyebrow">/ REQUEST A QUOTE</span>
        <h2 class="h2" style="margin:1rem 0 1.6rem">سجّل طلبك</h2>
        <form data-validate data-wa="$C{wa}" data-subject="طلب خدمة من الموقع" novalidate>
          @{[form_msg()]}
          <div class="fgrid">
            <div class="field"><label for="o-name">الاسم <i>*</i></label><input id="o-name" name="name" type="text" placeholder="الاسم بالكامل" required><span class="err">من فضلك أدخل الاسم</span></div>
            <div class="field"><label for="o-phone">الموبايل <i>*</i></label><input id="o-phone" name="phone" type="tel" inputmode="tel" placeholder="01xxxxxxxxx" required><span class="err">من فضلك أدخل رقم الموبايل</span></div>
            <div class="field"><label for="o-email">البريد الإلكتروني <i>*</i></label><input id="o-email" name="email" type="email" placeholder="name\@example.com" required><span class="err">من فضلك أدخل بريداً صحيحاً</span></div>
            <div class="field"><label for="o-city">المحافظة / الموقع</label><input id="o-city" name="city" type="text" placeholder="مثال: القاهرة الجديدة"></div>
            <div class="field full"><label for="o-service">اختيار الخدمة <i>*</i></label>
              <select id="o-service" name="service" required><option value="">— اختر الخدمة —</option>$opts</select>
              <span class="err">من فضلك اختر الخدمة</span></div>
            <div class="field full"><label for="o-msg">تفاصيل الطلب <i>*</i></label><textarea id="o-msg" name="message" placeholder="اكتب تفاصيل المشروع: المساحة، الموقع، الجدول الزمني..." required></textarea><span class="err">من فضلك اكتب تفاصيل الطلب</span></div>
            @{[captcha()]}
          </div>
          <button class="btn btn-aqua btn-lg" type="submit" style="margin-top:1.5rem">@{[ic('send','ic')]} تسجيل الطلب</button>
          @{[form_note()]}
        </form>
      </div>
      <aside data-rv data-delay="0.1">
        <h3 class="h3" style="margin-bottom:1.1rem">تفضل الاتصال المباشر؟</h3>
        <div style="display:grid;gap:12px">
          <a class="btn btn-aqua" href="https://api.whatsapp.com/send?phone=$C{wa}" target="_blank" rel="noopener" style="justify-content:center">@{[ic('wa','ic')]} واتساب</a>
          <a class="btn btn-ghost" href="tel:$C{mobile}" style="justify-content:center">@{[ic('phone','ic')]} <span class="tnum">$C{mobile}</span></a>
          <a class="btn btn-ghost" href="mailto:$C{email}" style="justify-content:center">@{[ic('mail','ic')]} البريد الإلكتروني</a>
        </div>
        <h3 class="h3" style="margin:2.2rem 0 1.1rem">خدماتنا</h3>
        @{[svclist_all()]}
      </aside>
    </div>
  </div>
</section>

@{[cta_band()]}
HTML
page('order.html', "اطلب الآن — $C{full}", 'سجل طلب خدمة من شركة أكوا مارين ووتر سيستمز: حمامات سباحة، نوافير، محطات مياه، غرف سونا وبخار، شبكات مياه.', 'order.html', $body);
}

sub captcha {
  return q{<div class="captcha field"><span class="q">للتأكيد، ما ناتج <b><span class="sum-a">3</span> + <span class="sum-b">4</span></b> ؟</span>}
    . q{<input class="sum-in" type="text" inputmode="numeric" aria-label="ناتج الجمع" required>}
    . qq{<button type="button" class="reload" aria-label="سؤال آخر">} . ic('refresh') . q{</button>}
    . q{<span class="err">الإجابة غير صحيحة</span></div>};
}
sub form_msg {
  return qq{<div class="form-msg">} . ic('check') . q{<span>تم تجهيز رسالتك وفتحها في واتساب لإرسالها إلى فريقنا. إذا لم تفتح النافذة تلقائياً، من فضلك اتصل بنا مباشرة.</span></div>};
}
sub form_note {
  return qq{<p class="form-note">} . ic('info') . q{<span>هذا الموقع نسخة ثابتة بدون خادم بريد؛ يتم تحويل بيانات النموذج إلى واتساب الشركة لإرسالها مباشرة. يمكنك أيضاً مراسلتنا على البريد الإلكتروني.</span></p>};
}

print "Done.\n";
