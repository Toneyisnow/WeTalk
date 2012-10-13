DROP TABLE lessons;
DROP TABLE sentences;
DROP TABLE users;
DROP TABLE userrecords;

CREATE TABLE lessons ( id INTEGER PRIMARY KEY, nameCN VARCHAR(50), nameEN VARCHAR(50), description TEXT);
CREATE TABLE sentences ( id INTEGER, lessonId INTEGER, name VARCHAR(50), description TEXT, fulltext_en TEXT, fulltext_ch TEXT, fulltext_py TEXT, fulltext_bench TEXT);
CREATE TABLE users ( username VARCHAR(50), displayname VARCHAR(50));
CREATE TABLE userrecords ( username VARCHAR(50), lessonId INTEGER, sentenceId INTEGER, recordMark FLOAT);

INSERT INTO lessons (id, nameEN, nameCN, description) VALUES (1, 'Basic Expressions', '基本表达', 'Basic Expressions');
INSERT INTO lessons (id, nameEN, nameCN, description) VALUES (2, 'Personal Information', '个人信息', 'Personal Information');
INSERT INTO lessons (id, nameEN, nameCN, description) VALUES (3, 'Eating out', '外出就餐', 'Eating out');
INSERT INTO lessons (id, nameEN, nameCN, description) VALUES (4, 'Shopping', '购物', 'Shopping');
INSERT INTO lessons (id, nameEN, nameCN, description) VALUES (5, 'Going out', '出行', 'Going out');
INSERT INTO lessons (id, nameEN, nameCN, description) VALUES (6, 'At the hotel', '酒店', 'At the hotel');
INSERT INTO lessons (id, nameEN, nameCN, description) VALUES (7, 'Recreation and Leisure Life', '休闲娱乐', 'Recreation and Leisure Life');
INSERT INTO lessons (id, nameEN, nameCN, description) VALUES (8, 'Being a guest', '作客', 'Being a guest');
INSERT INTO lessons (id, nameEN, nameCN, description) VALUES (9, 'Parties', '聚会', 'Parties');
INSERT INTO lessons (id, nameEN, nameCN, description) VALUES (10, 'Experiencing Problems', '', 'Experiencing Problems');

INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (1, 1, "-", 'Hello.', '您好', 'Nin hao!', 'nin hao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench)
	VALUES (2, 1, "-", "Good morning!", '早上好', 'Zaoshang hao!', 'zao shang hao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (3, 1, "-", "Good evening!", '晚上好', 'Wanshang hao!', 'wan shang hao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (4, 1, "-", "Good night!", '晚安', 'Wan an!', 'wan an');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (5, 1, "-", "Goodbye!", '再见', 'Zaijian!', 'zai jian');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (6, 1, "-", "See you tomorrow!", '明天见', 'Mingtian jian!', 'ming tian jian');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (7, 1, "-", "Let's keep in touch.", '有空常联系', 'Youkong chang lianxi.', 'you kong chang lian xi');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (8, 1, "-", "Thank you.", '谢谢', 'Xiexie!', 'xie xie');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (9, 1, "-", "Sorry for troubling you.", '麻烦您了', 'Mafan nin le.', 'ma fan nin le');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (10, 1, "-", "Never mind!", '不客气', 'Bu keqi!', 'bu ke qi');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (11, 1, "-", "You're quite welcome.", '你太客气了', 'Ni tai keqi le.', 'ni tai ke qi le');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (12, 1, "-", "I'm sorry.", '对不起', 'Duibuqi!', 'dui bu qi');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (13, 1, "-", "It doesn't matter.", '没关系', 'Mei guanxi.', 'mei guan xi');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (14, 1, "-", "I'm really sorry!", '真不好意思', 'Zhen buhao yisi!', 'zhen bu hao yi si');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (15, 1, "-", "Good idea!", '好主意', 'Hao zhuyi!', 'hao zhuyi');

INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (1, 2, "-", "May I know your surname?", '您贵姓?', 'Nin guixing?', 'nin gui xing');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (2, 2, "-", "Nice to meet you.", '认识您很高兴', 'Renshi nin hen gaoxing.', 'ren shi nin hen gao xing');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (3, 2, "-", "This is my business card.", '这是我的名片', 'Zhe shi wo de mingpian.', 'zhe shi wo de ming pian');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (4, 2, "-", "How old are you?", '你今年多大?', 'Ni jinnian duo da?', 'ni jinnian duo da');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (5, 2, "-", "You look so young.", '你看起来很年轻', 'Ni kanqilai hen nianqing', 'ni kan qi lai hen nian qing');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (6, 2, "-", "Which country are you from?", '你是哪国人?', 'Ni shi naguo ren?', 'ni shi naguo ren');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (7, 2, "-", "I'm from Shanghai.", '我是上海人', 'Wo shi shanghai ren.', 'wo shi shang hai ren');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (8, 2, "-", "I like this country.", '我很喜欢这个国家', 'Wo hen xihuan zhege guojia.', 'wo hen xi huan zhe ge guo jia');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (9, 2, "-", "Where do you work?", '你在哪儿工作?', 'Ni zai nar gongzuo?', 'ni zai nar gong zuo');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (10, 2, "-", "I work in the bank.", '我在银行工作', 'Wo zai yinhang gongzuo.', 'wo zai yin hang gong zuo');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (11, 2, "-", "I want to change my job.", '我想换个工作', 'Wo xiang huan ge gongzuo.', 'wo xiang huan ge gong zuo');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (12, 2, "-", "I have to work overtime tonight.", '我今天晚上加班', 'Wo jintian wanshang jiaban.', 'wo jin tian wan shang jia ban');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (13, 2, "-", "What are your hobbies?", '你有什么爱好?', 'Ni you shenme aihao?', 'ni you shen me ai hao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (14, 2, "-", "I like sports.", '我喜欢运动', 'Wo xihuan yundong.', 'wo xi huan yun dong');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (15, 2, "-", "I like watching movies best.", '我最爱看电影', 'Wo zui ai kan dianying.', 'wo zui ai kan dian ying');



INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (1, 3, "-", "What do you want to eat?", '你想吃什么?', 'Ni xiang chi shenme?', 'ni xiang chi shen me');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (2, 3, "-", "I want to eat Janapese food.", '我想吃日本菜', 'Wo xiang chi riben cai.', 'wo xiang chi ri ben cai');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (3, 3, "-", "Let's eat out.", '我们出去出吧', 'Women chuqu chi ba.', 'wo men chu qu chi ba');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (4, 3, "-", "Are there any rooms?", '有包间吗?', 'You baojian ma?', 'you bao jian ma');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (5, 3, "-", "Come in, please.", '里面请.', 'Limian qing.', 'li mian qing');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (6, 3, "-", "Order, please.", '服务员,点菜', 'Fuwuyuan, diancai', 'fu wu yuan dian cai');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (7, 3, "-", "Is this dish spicy?", '这个菜辣吗?', 'Zhege cai la ma?', 'zhe ge cai la ma');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (8, 3, "-", "That's all, thank you.", '先点这些吧', 'Xian dian zhexie ba.', 'xian dian zhe xie ba');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (9, 3, "-", "Please don't put a lot of sugar on it.", '少放点糖', 'Shao fang dian tang.', 'shao fang dian tang');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (10, 3, "-", "No chili, please.", '别放辣椒', 'Bie fang lajiao.', 'bie fang la jiao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (11, 3, "-", "I do not eat pork.", '我不吃猪肉', 'Wo bu chi zhurou.', 'wo bu chi zhu rou');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (12, 3, "-", "I don't know how to use chopsticks.", '我不会用筷子', 'Wo buhui yong kuaizi.', 'wo bu hui yong kuai zi');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (13, 3, "-", "This dish looks good.", '这道菜看上去不错', 'Zhe dao cai kanshangqu bucuo.', 'zhe dao cai kan shang qu bu cuo');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (14, 3, "-", "Excuse me, please box the leftovers.", '服务员,打包', 'Fuwuyuan, dabao.', 'fu wu yuan, da bao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (15, 3, "-", "It's on me today.", '今天我请客', 'Jintian wo qingke.', 'jin tian wo qing ke');

INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (1, 4, "-", "What do you want to eat?", '你想吃什么?', 'Ni xiang chi shenme?', 'ni xiang chi shen me');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (2, 4, "-", "I want to eat Janapese food.", '我想吃日本菜', 'Wo xiang chi riben cai.', 'wo xiang chi ri ben cai');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (3, 4, "-", "Let's eat out.", '我们出去出吧', 'Women chuqu chi ba.', 'women chuqu chi ba');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (4, 4, "-", "Are there any rooms?", '有包间吗?', 'You baojian ma?', 'you baojian ma');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (5, 4, "-", "Come in, please.", '里面请.', 'Limian qing.', 'limian qing');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (6, 4, "-", "Order, please.", '服务员,点菜', 'Fuwuyuan, diancai', 'fuwuyuan diancai');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (7, 4, "-", "Is this dish spicy?", '这个菜辣吗?', 'Zhege cai la ma?', 'zhege cai la ma');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (8, 4, "-", "That's all, thank you.", '先点这些吧', 'Xian dian zhexie ba.', 'xian dian zhexie ba');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (9, 4, "-", "Please don't put a lot of sugar on it.", '少放点糖', 'Shao fang dian tang.', 'shao fang dian tang');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (10, 4, "-", "No chili, please.", '别放辣椒', 'Bie fang lajiao.', 'bie fang lajiao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (11, 4, "-", "I do not eat pork.", '我不吃猪肉', 'Wo bu chi zhurou.', 'wo bu chi zhurou');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (12, 4, "-", "I don't know how to use chopsticks.", '我不会用筷子', 'Wo buhui yong kuaizi.', 'wo buhui yong kuaizi');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (13, 4, "-", "This dish looks good.", '这道菜看上去不错', 'Zhe dao cai kanshangqu bucuo.', 'zhe dao cai kanshangqu bucuo');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (14, 4, "-", "Excuse me, please box the leftovers.", '服务员,打包', 'Fuwuyuan, dabao.', 'fuwuyuan, dabao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (15, 4, "-", "It's on me today.", '今天我请客', 'Jintian wo qingke.', 'jintian wo qingke');

INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (1, 5, "-", "What do you want to eat?", '你想吃什么?', 'Ni xiang chi shenme?', 'ni xiang chi shenme');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (2, 5, "-", "I want to eat Janapese food.", '我想吃日本菜', 'Wo xiang chi riben cai.', 'wo xiang chi riben cai');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (3, 5, "-", "Let's eat out.", '我们出去出吧', 'Women chuqu chi ba.', 'women chuqu chi ba');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (4, 5, "-", "Are there any rooms?", '有包间吗?', 'You baojian ma?', 'you baojian ma');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (5, 5, "-", "Come in, please.", '里面请.', 'Limian qing.', 'limian qing');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (6, 5, "-", "Order, please.", '服务员,点菜', 'Fuwuyuan, diancai', 'fuwuyuan diancai');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (7, 5, "-", "Is this dish spicy?", '这个菜辣吗?', 'Zhege cai la ma?', 'zhege cai la ma');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (8, 5, "-", "That's all, thank you.", '先点这些吧', 'Xian dian zhexie ba.', 'xian dian zhexie ba');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (9, 5, "-", "Please don't put a lot of sugar on it.", '少放点糖', 'Shao fang dian tang.', 'shao fang dian tang');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (10, 5, "-", "No chili, please.", '别放辣椒', 'Bie fang lajiao.', 'bie fang lajiao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (11, 5, "-", "I do not eat pork.", '我不吃猪肉', 'Wo bu chi zhurou.', 'wo bu chi zhurou');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (12, 5, "-", "I don't know how to use chopsticks.", '我不会用筷子', 'Wo buhui yong kuaizi.', 'wo buhui yong kuaizi');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (13, 5, "-", "This dish looks good.", '这道菜看上去不错', 'Zhe dao cai kanshangqu bucuo.', 'zhe dao cai kanshangqu bucuo');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (14, 5, "-", "Excuse me, please box the leftovers.", '服务员,打包', 'Fuwuyuan, dabao.', 'fuwuyuan, dabao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (15, 5, "-", "It's on me today.", '今天我请客', 'Jintian wo qingke.', 'jintian wo qingke');

INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (1, 6, "-", "What do you want to eat?", '你想吃什么?', 'Ni xiang chi shenme?', 'ni xiang chi shenme');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (2, 6, "-", "I want to eat Janapese food.", '我想吃日本菜', 'Wo xiang chi riben cai.', 'wo xiang chi riben cai');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (3, 6, "-", "Let's eat out.", '我们出去出吧', 'Women chuqu chi ba.', 'women chuqu chi ba');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (4, 6, "-", "Are there any rooms?", '有包间吗?', 'You baojian ma?', 'you baojian ma');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (5, 6, "-", "Come in, please.", '里面请.', 'Limian qing.', 'limian qing');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (6, 6, "-", "Order, please.", '服务员,点菜', 'Fuwuyuan, diancai', 'fuwuyuan diancai');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (7, 6, "-", "Is this dish spicy?", '这个菜辣吗?', 'Zhege cai la ma?', 'zhege cai la ma');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (8, 6, "-", "That's all, thank you.", '先点这些吧', 'Xian dian zhexie ba.', 'xian dian zhexie ba');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (9, 6, "-", "Please don't put a lot of sugar on it.", '少放点糖', 'Shao fang dian tang.', 'shao fang dian tang');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (10, 6, "-", "No chili, please.", '别放辣椒', 'Bie fang lajiao.', 'bie fang lajiao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (11, 6, "-", "I do not eat pork.", '我不吃猪肉', 'Wo bu chi zhurou.', 'wo bu chi zhurou');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (12, 6, "-", "I don't know how to use chopsticks.", '我不会用筷子', 'Wo buhui yong kuaizi.', 'wo buhui yong kuaizi');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (13, 6, "-", "This dish looks good.", '这道菜看上去不错', 'Zhe dao cai kanshangqu bucuo.', 'zhe dao cai kanshangqu bucuo');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (14, 6, "-", "Excuse me, please box the leftovers.", '服务员,打包', 'Fuwuyuan, dabao.', 'fuwuyuan, dabao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (15, 6, "-", "It's on me today.", '今天我请客', 'Jintian wo qingke.', 'jintian wo qingke');

INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (1, 7, "-", "What do you want to eat?", '你想吃什么?', 'Ni xiang chi shenme?', 'ni xiang chi shenme');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (2, 7, "-", "I want to eat Janapese food.", '我想吃日本菜', 'Wo xiang chi riben cai.', 'wo xiang chi riben cai');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (3, 7, "-", "Let's eat out.", '我们出去出吧', 'Women chuqu chi ba.', 'women chuqu chi ba');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (4, 7, "-", "Are there any rooms?", '有包间吗?', 'You baojian ma?', 'you baojian ma');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (5, 7, "-", "Come in, please.", '里面请.', 'Limian qing.', 'limian qing');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (6, 7, "-", "Order, please.", '服务员,点菜', 'Fuwuyuan, diancai', 'fuwuyuan diancai');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (7, 7, "-", "Is this dish spicy?", '这个菜辣吗?', 'Zhege cai la ma?', 'zhege cai la ma');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (8, 7, "-", "That's all, thank you.", '先点这些吧', 'Xian dian zhexie ba.', 'xian dian zhexie ba');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (9, 7, "-", "Please don't put a lot of sugar on it.", '少放点糖', 'Shao fang dian tang.', 'shao fang dian tang');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (10, 7, "-", "No chili, please.", '别放辣椒', 'Bie fang lajiao.', 'bie fang lajiao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (11, 7, "-", "I do not eat pork.", '我不吃猪肉', 'Wo bu chi zhurou.', 'wo bu chi zhurou');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (12, 7, "-", "I don't know how to use chopsticks.", '我不会用筷子', 'Wo buhui yong kuaizi.', 'wo buhui yong kuaizi');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (13, 7, "-", "This dish looks good.", '这道菜看上去不错', 'Zhe dao cai kanshangqu bucuo.', 'zhe dao cai kanshangqu bucuo');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (14, 7, "-", "Excuse me, please box the leftovers.", '服务员,打包', 'Fuwuyuan, dabao.', 'fuwuyuan, dabao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (15, 7, "-", "It's on me today.", '今天我请客', 'Jintian wo qingke.', 'jintian wo qingke');

INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (1, 8, "-", "What do you want to eat?", '你想吃什么?', 'Ni xiang chi shenme?', 'ni xiang chi shenme');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (2, 8, "-", "I want to eat Janapese food.", '我想吃日本菜', 'Wo xiang chi riben cai.', 'wo xiang chi riben cai');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (3, 8, "-", "Let's eat out.", '我们出去出吧', 'Women chuqu chi ba.', 'women chuqu chi ba');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (4, 8, "-", "Are there any rooms?", '有包间吗?', 'You baojian ma?', 'you baojian ma');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (5, 8, "-", "Come in, please.", '里面请.', 'Limian qing.', 'limian qing');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (6, 8, "-", "Order, please.", '服务员,点菜', 'Fuwuyuan, diancai', 'fuwuyuan diancai');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (7, 8, "-", "Is this dish spicy?", '这个菜辣吗?', 'Zhege cai la ma?', 'zhege cai la ma');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (8, 8, "-", "That's all, thank you.", '先点这些吧', 'Xian dian zhexie ba.', 'xian dian zhexie ba');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (9, 8, "-", "Please don't put a lot of sugar on it.", '少放点糖', 'Shao fang dian tang.', 'shao fang dian tang');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (10, 8, "-", "No chili, please.", '别放辣椒', 'Bie fang lajiao.', 'bie fang lajiao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (11, 8, "-", "I do not eat pork.", '我不吃猪肉', 'Wo bu chi zhurou.', 'wo bu chi zhurou');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (12, 8, "-", "I don't know how to use chopsticks.", '我不会用筷子', 'Wo buhui yong kuaizi.', 'wo buhui yong kuaizi');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (13, 8, "-", "This dish looks good.", '这道菜看上去不错', 'Zhe dao cai kanshangqu bucuo.', 'zhe dao cai kanshangqu bucuo');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (14, 8, "-", "Excuse me, please box the leftovers.", '服务员,打包', 'Fuwuyuan, dabao.', 'fuwuyuan, dabao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (15, 8, "-", "It's on me today.", '今天我请客', 'Jintian wo qingke.', 'jintian wo qingke');

INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (1, 9, "-", "What do you want to eat?", '你想吃什么?', 'Ni xiang chi shenme?', 'ni xiang chi shenme');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (2, 9, "-", "I want to eat Janapese food.", '我想吃日本菜', 'Wo xiang chi riben cai.', 'wo xiang chi riben cai');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (3, 9, "-", "Let's eat out.", '我们出去出吧', 'Women chuqu chi ba.', 'women chuqu chi ba');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (4, 9, "-", "Are there any rooms?", '有包间吗?', 'You baojian ma?', 'you baojian ma');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (5, 9, "-", "Come in, please.", '里面请.', 'Limian qing.', 'limian qing');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (6, 9, "-", "Order, please.", '服务员,点菜', 'Fuwuyuan, diancai', 'fuwuyuan diancai');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (7, 9, "-", "Is this dish spicy?", '这个菜辣吗?', 'Zhege cai la ma?', 'zhege cai la ma');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (8, 9, "-", "That's all, thank you.", '先点这些吧', 'Xian dian zhexie ba.', 'xian dian zhexie ba');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (9, 9, "-", "Please don't put a lot of sugar on it.", '少放点糖', 'Shao fang dian tang.', 'shao fang dian tang');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (10, 9, "-", "No chili, please.", '别放辣椒', 'Bie fang lajiao.', 'bie fang lajiao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (11, 9, "-", "I do not eat pork.", '我不吃猪肉', 'Wo bu chi zhurou.', 'wo bu chi zhurou');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (12, 9, "-", "I don't know how to use chopsticks.", '我不会用筷子', 'Wo buhui yong kuaizi.', 'wo buhui yong kuaizi');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (13, 9, "-", "This dish looks good.", '这道菜看上去不错', 'Zhe dao cai kanshangqu bucuo.', 'zhe dao cai kanshangqu bucuo');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (14, 9, "-", "Excuse me, please box the leftovers.", '服务员,打包', 'Fuwuyuan, dabao.', 'fuwuyuan, dabao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (15, 9, "-", "It's on me today.", '今天我请客', 'Jintian wo qingke.', 'jintian wo qingke');

INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (1, 10, "-", "What do you want to eat?", '你想吃什么?', 'Ni xiang chi shenme?', 'ni xiang chi shenme');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (2, 10, "-", "I want to eat Janapese food.", '我想吃日本菜', 'Wo xiang chi riben cai.', 'wo xiang chi riben cai');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (3, 10, "-", "Let's eat out.", '我们出去出吧', 'Women chuqu chi ba.', 'women chuqu chi ba');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (4, 10, "-", "Are there any rooms?", '有包间吗?', 'You baojian ma?', 'you baojian ma');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (5, 10, "-", "Come in, please.", '里面请.', 'Limian qing.', 'limian qing');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (6, 10, "-", "Order, please.", '服务员,点菜', 'Fuwuyuan, diancai', 'fuwuyuan diancai');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (7, 10, "-", "Is this dish spicy?", '这个菜辣吗?', 'Zhege cai la ma?', 'zhege cai la ma');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (8, 10, "-", "That's all, thank you.", '先点这些吧', 'Xian dian zhexie ba.', 'xian dian zhexie ba');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (9, 10, "-", "Please don't put a lot of sugar on it.", '少放点糖', 'Shao fang dian tang.', 'shao fang dian tang');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (10, 10, "-", "No chili, please.", '别放辣椒', 'Bie fang lajiao.', 'bie fang lajiao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (11, 10, "-", "I do not eat pork.", '我不吃猪肉', 'Wo bu chi zhurou.', 'wo bu chi zhurou');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (12, 10, "-", "I don't know how to use chopsticks.", '我不会用筷子', 'Wo buhui yong kuaizi.', 'wo buhui yong kuaizi');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (13, 10, "-", "This dish looks good.", '这道菜看上去不错', 'Zhe dao cai kanshangqu bucuo.', 'zhe dao cai kanshangqu bucuo');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (14, 10, "-", "Excuse me, please box the leftovers.", '服务员,打包', 'Fuwuyuan, dabao.', 'fuwuyuan, dabao');
INSERT INTO sentences (id, lessonId, name, fulltext_en, fulltext_ch, fulltext_py, fulltext_bench) 
	VALUES (15, 10, "-", "It's on me today.", '今天我请客', 'Jintian wo qingke.', 'jintian wo qingke');


