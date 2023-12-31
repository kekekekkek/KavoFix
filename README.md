# KavoFix
Серверный скрипт, который позволит Вам беспрепятственно печатать сообщения в игровой чат на кириллице (русском языке). Вам не нужно будет постоянно указывать какие-либо дополнительные символы на латинице (английском языке) в начале или конце предложения.

# Установка
Установка плагина состоит из нескольких шагов:
1. [Скачайте](https://github.com/kekekekkek/KavoFix/archive/refs/heads/main.zip) данный плагин;
2. Откройте директорию `..\Sven Co-op\svencoop_addon\scripts\plugins` и поместите скрипт `KavoFix.as` туда;
3. Далее, перейдите в папку `..\Sven Co-op\svencoop` и найдите там текстовый файл `default_plugins.txt`;
4. Откройте этот файл и вставьте в него следующий текст:
```
	"plugin"
	{
		"name" "KavoFix"
		"script" "KavoFix"
	}
```
5. Сохраните изменения и запустите игру (сервер).

**ЗАПОМНИТЕ**: Этот скрипт будет работать только на Вашем сервере.<br>
**ЗАПОМНИТЕ**: Этот скрипт "конфликтует" с другим плагином под названием [ChatColors](https://github.com/wootguy/ChatColors). Вам нужно будет модифицировать плагины `KavoFix.as` и `ChatColors.as`, если Вы хотите, чтобы эти два скрипта работали вместе корректно.<br>
**ЗАПОМНИТЕ**: Команда `!askavofix` необходима для того, чтобы правильно взаимодействовать с другим [плагином](https://github.com/kekekekkek/kavofix_for_Sven_Co-op/tree/svenmod) для [SvenMod](https://github.com/sw1ft747/svenmod).<br>
**ЗАПОМНИТЕ**: Также, Вы можете отправлять сообщения в командный чат. Сообщения командного чата будут видны только Вашей команде.

# Результат
* Скриншот 1<br><br>
![Screenshot_1](https://github.com/kekekekkek/KavoFix/blob/main/Images/Screenshot_1.png)
* Скриншот 2<br><br>
![Screenshot_2](https://github.com/kekekekkek/KavoFix/blob/main/Images/Screenshot_2.png)
