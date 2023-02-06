# WorldSim3D - Free Pascal Header

**En: General:**  
- Renders: Software, BurningsVideo, OpenGL 1.2-4.x, Direct3D 9, Null-driver  
- Functions for working with the timer, to get information about the user's OS  

**Supported OS:**  
- Windows 32-bit XP/Vista/7/8/8.1/10  
- Windows 64-bit XP/Vista/7/8/8.1/10  
~~- Linux 64-bit: Ubuntu, Debian, Mint, etc.~~  
  
**Features:**  
- Animated water surface  
- Dynamic shadows using a stencil buffer  
- Geotrain with lod-levels  
- Tree generator  
- Billboards  
- Bump mapping  
- Parallax mapping  
- Transparent objects  
- Light maps (light maps)  
- Customizable particle system for snow, smoke, fire, etc.  
- Sphere mapping  
- Texture animation  
- Skyboxes and skydomes  
- Fog  
- Dimensional clouds  
- Realistic clouds  
- Sun glare (LensFlare )  
- Animated grass  
- Lightning  
- Beams (laser, weapons, etc.)  
- Archive handling (.zip, .pak, .pk3, .npk)  
  
**Lighting:**  
- ambient  
- diffuse  
- emissive  
- specular  
- gradual reduction depending on distance  
- point, directional, spot  
- lighting effects  
  
**Shaders:**  
- Pixel and Vertex Shaders 1.1 to 3.0  
- ARB Fragment and Vertex Programs  
- HLSL  
- GLSL  
- Xeffects (optional add-on)  
- Geometric (OpenGL 3.3)  
  
**Postprocessing Effects:**  
- PUNCH  
- PIXELATE  
- PIXELATEBANDS  
- DARKEN  
- LIGHTEN  
- RANGE  
- POSTERIZE  
- INVERT  
- TINT  
- CURVES  
- GREYSCALE  
- SEPIA  
- SATURATE  
- VIGNETTE  
- NOISE  
- COLORNOISE  
- PURENOISE  
- HBLUR  
- VBLUR  
- HSHARPEN  
- VSHARPEN  
- BIBLUR  
- HBLURDOFFAR  
- VBLURDOFFAR  
- HBLURDOFNEAR  
- VBLURDOFNEAR  
- LINEARBLUR  
- RADIALBLUR  
- RADIALBEAM  
- ROTATIONALBLUR  
- OVERLAY  
- OVERLAYNEG  
- MOTIONBLUR  
- HAZE  
- HAZEDEPTH  
- DEPTH  
- OCCLUSION  
- BLUR  
- SHARPEN  
- BLURDOFFAR  
- BLURDOFNEAR  
- BLURDOF  
- BLOOM  
- GLOOM  
- NIGHTVISION  
- MONITOR  
- WATERCOLOR  
  
**BSP-cards:**  
- BSP-maps compatible with Quake 3 maps  
- Entities  
- Shaders (torches, lava, etc.)  
  
**Particle System:**  
- Customizable Particle Nodes  
- Multiple particle emitters (cubic, cylindrical, circular, etc.)  
- Affectors (fading, gravity, color change, etc.)  
  
**Shadows:**  
- Stensional (in two versions: from Irrlicht 1.7.3 and from Irrlicht 1.9)  
- Shaders (using XEffects)  
  
**Working with 2D:**  
- Drawing graphical entities (line, rectangle, ellipse, point, polygon)  
- Displaying pictures with zoom and rotation options  
- Access to image pixel color change  
- Flags for texture display in different modes (16/32 bit, mip_maps, alpha channel)  
  
**Graphics formats:**  
- JPEG (.jpg),  
- DirectDraw Surface (.dds)(only 32 bit versions) (DXT2, DXT3, DXT4, DXT5, based on code from Nvidia and Randy Reddig)  
- Portable Network Graphics (.png)  
- Truevision Targa (.tga)  
- Windows Bitmap (.bmp)  
- Zsoft Paintbrush (.pcx)  
- Portable Pixmaps (.ppm)  
- Adobe Photoshop (.psd)  
- Quake 2 textures (.wal)  
- SGI truecolor textures (.rgb)  
  
**Font handling:**  
- Built in functions for .bmp and .png  
- Alternate xml loading  
- Hooked up FreeType library for .ttf  
  
**Materials:**  
- Colors: ambient, diffuse, emissive, specular  
- Blending  
- Shininess  
  
**Material types:**  
- SOLID  
- SOLID_2_LAYER  
- LIGHTMAP  
- LIGHTMAP_ADD  
- LIGHTMAP_M2  
- LIGHTMAP_M4  
- LIGHTMAP_LIGHTING  
- LIGHTMAP_LIGHTING_M2  
- LIGHTMAP_LIGHTING_M4  
- DETAIL_MAP  
- SPHERE_MAP  
- REFLECTION_2_LAYER  
- TRANSPARENT_ADD_COLOR  
- TRANSPARENT_ALPHA_CHANNEL  
- TRANSPARENT_ALPHA_CHANNEL_REF  
- TRANSPARENT_VERTEX_ALPHA  
- TRANSPARENT_REFLECTION_2_LAYER  
- NORMAL_MAP_SOLID  
- NORMAL_MAP_TRANSPARENT_ADD_COLOR  
- NORMAL_MAP_TRANSPARENT_VERTEX_ALPHA  
- PARALLAX_MAP_SOLID  
- PARALLAX_MAP_TRANSPARENT_ADD_COLOR  
- PARALLAX_MAP_TRANSPARENT_VERTEX_ALPHA  
- FOUR_DETAIL_MAP  
  
**Material flags:**  
- WIREFRAME  
- POINTCLOUD  
- GOURAUD_SHADING  
- LIGHTING  
- ZBUFFER  
- ZWRITE_ENABLE  
- BACK_FACE_CULLING  
- FRONT_FACE_CULLING  
- BILINEAR_FILTER  
- TRILINEAR_FILTER  
- ANISOTROPIC_FILTER  
- FOG_ENABLE  
- NORMALIZE_NORMALS  
- TEXTURE_WRAP  
- ANTI_ALIASING  
- COLOR_MASK  
- COLOR_MATERIAL  
  
**Working with meshes:**  
- Set the color of meshes tops  
- Normal or Parallax mapping for static meshes  
- Access to individual meshbuffers of a given meshes  
  
**Animators for static objects:**  
- rotation around its axis  
- rotation around another object  
- collision  
- removal from the scene  
- gradual disappearance  
- straight line movement  
- movement along a curve (spline)  
  
**Processing the scene:**  
- Working with objects: show, hide, etc.  
- Object links: parent-child (or master-child).  
- Saving all scene settings in one file  
- Working with decals  
- Realistic water 
- 
**User Graphical User Interface (GUI):**  
- Text box  
- Text edit box  
- Additional windows  
- Buttons  
- Scrollbar  
- Drop down lists  
- Checkbox  
- Image  
- File selection dialog  
- Font setting for interface elements  
- Button and checkbox groups and more.  
  
**Audio handling (Open AL is used):**  
- Supported formats: ogg, wav  
- 2D and 3D sound  
- doppler effect  
- fading with distance  
- sound adjustments (Volume, Gain, Pitch, Strength, RollOffFactor, etc.)  
- sound filters (LOWPASS, HIGHPASS, BANDPASS)  
- OpenAL EAX effects:  
- EAX_REVERB  
- REVERB  
- CHORUS  
- DISTORTION  
- ECHO  
- FLANGER  
- FREQUENCY_SHIFTER  
- VOCAL_MORPHER  
- PITCH_SHIFTER  
- RING_MODULATOR  
- AUTOWAH  
- COMPRESSOR  
- EQUALIZER  
  
  
**Video processing:**  
- Supported formats: ogg theora (.ogg)  
- Basic functions for working with video: play, pause, rewind, etc.  
- Video can be played back on 2D image and on texture of any 3D object.  
  
**Networking (kNet library is connected):**.  
- Supported transmission/reception protocols: TCP/IP, UDP  
- Transmitting and receiving packets containing types (Integer, float, string).  
- Possibility to create combined packets  
- Server organization  
- Client organization  
  
**Cameras:** Cameras  
- Normal (good for any purpose)  
- FPS (suitable for shooters)  
- Maya (suitable for editors)  
- TPS (suitable for RPGs)  
- RTS (suitable for strategy games)  
- Customize your standard camera options  
  
**Input devices:**  
- All standard keyboard functions (up to 169 keys)  
- All standard mouse functions (up to 5 buttons)  
- Joystick control (up to 32 buttons, up to 6 axes)  
  
**Scene optimization** 
- Mash in Octree mode  
- Mesh in Batching mode  
- Easy work with LOD (Level of Detail)  
- Force mapping of 16 or 32 bit textures  
- Rendering of large meshes (1-2 million polygons and more) through the graphics card (VBO optimization)  
- Visibility query (Occlusion Query technology)  
- visibility area manager  
  
**Math:**  
- built-in functions for working with vectors  
- built-in functions for number processing  
- set of type conversion functions (wUtil section)  
  
**XML handling:**  
- Reading xml files  
- Writing xml-files  
- You can write your own parsing functions for xml-files and any text formats  
  
**Model formats:**  
With animation:  
- B3D (.b3d, skeletal)  
- Microsoft DirectX (.x, binary and text, skeletal)  
- Milkshape (.ms3d, skeletal)  
- MDL Half Life 1 (.mdl, skeletal)  
- Quake 2 models (.md2, morphing)  
- Quake3 models (.md3, morphing)  
  
No animation:  
- 3D Studio meshes (.3ds)  
- Alias Wavefront Maya (.obj)  
- Lightwave objects (.lwo)  
- COLLADA 1.4 (.xml, .dae)  
- Microsoft DirectX (.x, binary and text)  
- Milkshape (.ms3d)  
- OGRE meshes (.mesh)  
- My3DTools 3 (.my3D)  
- Pulsar LMTools (.lmts)  
- Quake 3 levels (.bsp)  
- DeleD (.dmf)  
- FSRad oct (.oct)  
- Cartography shop 4 (.csm)  
- STL 3D files (.stl)  
- PLY 3D files (.ply)  
- Magica Voxel vox-models (.vox)  
  
**Physics:**  
  
**Basic:**  
- Collision Check  
- Both primitives and complex geometric shapes based on any mesh are used for collisions  
- Collision checking for interaction with a terrane  
- Gravity  
- Determining a collision point using vectors coming from an object or camera to another object (raycasting)  
- Detecting collisions with an object based on screen coordinates  
- Collision animator  
  
**Newton physics:**  
- primitive solids (cube, sphere, cone, capsule)  
- convex solids (Convex Hull)  
- nonconvex solids without mass (TreeMesh)  
- Compound Objects  
- water surface (Archimedes force)  
- solids interaction with BSP-maps  
- vehicle physics  
- physical joints (Hinge, Slider, Universal, UpVector, CorkScrew, Ball)  
- It is possible to connect other physics libraries, including PhysX, Tokamak, Spe and Bullet.

**RU: Возможности WorldSim3D**  
  
**Общее:**  
• Рендеры: Software, BurningsVideo, OpenGL 1.2-4.x, Direct3D 9, Null-driver  
• Функции для работы с таймером, для получения информации об ОС пользователя  


**Поддерживаемые ОС:**  
• Windows 32-bit XP/Vista/7/8/8.1/10  
• Windows 64-bit XP/Vista/7/8/8.1/10  
~~• Linux 64-bit: Ubuntu, Debian, Mint и др.~~  
  
**Особенности:**  
• Анимированная поверхность воды  
• Динамические тени с использованием стенсил буфера  
• Геотеррейн с lod-уровнями  
• Генератор деревьев  
• Билборды  
• Бамп мэппинг  
• Параллакс мэппинг  
• Прозрачные объекты  
• Карты освещения (light maps)  
• Настраиваемая система частиц для снега, дыма, огня и т.д.  
• Sphere mapping  
• Текстурная анимация  
• Скайбоксы и небесные своды (skydome)  
• Туман  
• Объёмные облака  
• Реалистичные облака  
• Блики от солнца (LensFlare )  
• Анимированная трава  
• Молния  
• Лучи (лазер, оружие и т.п.)  
• Работа с архивами (.zip, .pak, .pk3, .npk)  
  
**Освещение:**  
• ambient  
• diffuse  
• emissive  
• specular  
• постепенное уменьшение в зависимости от расстояния  
• точечный, направленный, spot  
• спецэффекты, связанные с освещением  
  
**Шейдеры:**  
• Pixel and Vertex Shaders 1.1 to 3.0  
• ARB Fragment and Vertex Programs  
• HLSL  
• GLSL  
• Xeffects (дополнительное расширение)  
• Геометрические (OpenGL 3.3)  
  
**Эффекты постобработки:**  
• PUNCH  
• PIXELATE  
• PIXELATEBANDS  
• DARKEN  
• LIGHTEN  
• RANGE  
• POSTERIZE  
• INVERT  
• TINT  
• CURVES  
• GREYSCALE  
• SEPIA  
• SATURATE  
• VIGNETTE  
• NOISE  
• COLORNOISE  
• PURENOISE  
• HBLUR  
• VBLUR  
• HSHARPEN  
• VSHARPEN  
• BIBLUR  
• HBLURDOFFAR  
• VBLURDOFFAR  
• HBLURDOFNEAR  
• VBLURDOFNEAR  
• LINEARBLUR  
• RADIALBLUR  
• RADIALBEAM  
• ROTATIONALBLUR  
• OVERLAY  
• OVERLAYNEG  
• MOTIONBLUR  
• HAZE  
• HAZEDEPTH  
• DEPTH  
• OCCLUSION  
• BLUR  
• SHARPEN  
• BLURDOFFAR  
• BLURDOFNEAR  
• BLURDOF  
• BLOOM  
• GLOOM  
• NIGHTVISION  
• MONITOR  
• WATERCOLOR  
  
**BSP-карты:**  
• BSP-карты, совместимые с картами Quake 3  
• сущности (Entity)  
• шейдеры (факелы, лава и др.)  
  
**Система частиц:**  
• Настраиваемые ноды частиц  
• Эмиттеры частиц нескольких видов (кубические, цилиндрические, кольцевые и др.)  
• Aффекторы (затухания, гравитации, изменения цвета и др.)  
  
**Тени:**  
• Стенсильные (в двух вариантах: от Irrlicht 1.7.3 и от Irrlicht 1.9)  
• Шейдерные (с использованием XEffects)  
  
**Работа с 2D:**  
• Рисование графических примитивов (линия, прямоугольник, эллипс, точка, полигон)  
• Отображение картинок с возможностью масштабирования и вращения  
• Доступ к изменению цвета пикселей изображения  
• Флаги для отображения текстур в разных режимах (16/32 бит, mip_maps, альфа канал)  
  
**Форматы графики:**  
• JPEG (.jpg),  
• DirectDraw Surface (.dds)(only 32 bit versions) (DXT2, DXT3, DXT4, DXT5, based on code from Nvidia and Randy Reddig)  
• Portable Network Graphics (.png)  
• Truevision Targa (.tga)  
• Windows Bitmap (.bmp)  
• Zsoft Paintbrush (.pcx)  
• Portable Pixmaps (.ppm)  
• Adobe Photoshop (.psd)  
• Quake 2 текстуры (.wal)  
• SGI truecolor текстуры (.rgb)  
  
**Работа со шрифтами:**  
• Встроенные функции для .bmp и .png  
• Альтернативная загрузка через xml  
• Подключена библиотека FreeType для .ttf  
  
**Материалы:**  
• Цвет: ambient, diffuse, emissive, specular  
• Смешивание (blending)  
• Shininess  
  
**Типы материалов:**  
• SOLID  
• SOLID_2_LAYER  
• LIGHTMAP  
• LIGHTMAP_ADD  
• LIGHTMAP_M2  
• LIGHTMAP_M4  
• LIGHTMAP_LIGHTING  
• LIGHTMAP_LIGHTING_M2  
• LIGHTMAP_LIGHTING_M4  
• DETAIL_MAP  
• SPHERE_MAP  
• REFLECTION_2_LAYER  
• TRANSPARENT_ADD_COLOR  
• TRANSPARENT_ALPHA_CHANNEL  
• TRANSPARENT_ALPHA_CHANNEL_REF  
• TRANSPARENT_VERTEX_ALPHA  
• TRANSPARENT_REFLECTION_2_LAYER  
• NORMAL_MAP_SOLID  
• NORMAL_MAP_TRANSPARENT_ADD_COLOR  
• NORMAL_MAP_TRANSPARENT_VERTEX_ALPHA  
• PARALLAX_MAP_SOLID  
• PARALLAX_MAP_TRANSPARENT_ADD_COLOR  
• PARALLAX_MAP_TRANSPARENT_VERTEX_ALPHA  
• FOUR_DETAIL_MAP  
  
**Флаги материалов:**  
• WIREFRAME  
• POINTCLOUD  
• GOURAUD_SHADING  
• LIGHTING  
• ZBUFFER  
• ZWRITE_ENABLE  
• BACK_FACE_CULLING  
• FRONT_FACE_CULLING  
• BILINEAR_FILTER  
• TRILINEAR_FILTER  
• ANISOTROPIC_FILTER  
• FOG_ENABLE  
• NORMALIZE_NORMALS  
• TEXTURE_WRAP  
• ANTI_ALIASING  
• COLOR_MASK  
• COLOR_MATERIAL  
  
**Работа с мешами:**  
• Установка цвета вершин меша  
• Normal или Parallax mapping для статических мешей  
• Доступ к отдельным мешбуфферам данного меша  
  
**Аниматоры для статических объектов:**  
• вращение вокруг своей оси  
• вращение вокруг другого объекта  
• столкновение  
• удаление из сцены  
• постепенное исчезновение  
• движение по прямой  
• движение по кривой (spline)  
  
**Работа со сценой:**  
• Работа с объектами: показать, скрыть и т.д.  
• Связи объектов: родитель - ребёнок (или главный - дочерний)  
• Сохранение всех настроек сцены в один файл  
• Работа с декалями  
• Реалистичная вода  
  
**Пользовательский графический нтерфейс (GUI):**  
• Поле для вывода текста  
• Поле для редактирования текста  
• Дополнительные окна  
• Кнопки  
• Скроллбар  
• Выпадающие списки  
• Чекбокс  
• Изображение  
• Диалог для выбора файла  
• Установка шрифта для элементов интерфейса  
• Группы кнопок и чекбоксов и многое др.  
  
**Работа со звуком (используется Open AL):**  
• Поддерживаемые форматы: ogg, wav  
• 2D и 3D-звук  
• эффект Допплера  
• затухание с расстоянием  
• регулировки звука (Volume, Gain, Pitch, Strength, RollOffFactor и др.)  
• звуковые фильтры (LOWPASS, HIGHPASS, BANDPASS)  
• эффекты OpenAL EAX:  
• EAX_REVERB  
• REVERB  
• CHORUS  
• DISTORTION  
• ECHO  
• FLANGER  
• FREQUENCY_SHIFTER  
• VOCAL_MORPHER  
• PITCH_SHIFTER  
• RING_MODULATOR  
• AUTOWAH  
• COMPRESSOR  
• EQUALIZER  
  
  
**Работа с видео:**  
• Поддерживаемые форматы: ogg Theora (.ogg)  
• Основные функции для работы с видео: воспроизведение, пауза, перемотка и др.  
• Возможность проигрывания видео на 2D-изображении и на текстуре любого 3D-объекта  
  
**Работа с сетью (подключена библиотека kNet):**  
• Поддерживаемые протоколы передачи/приема: TCP/IP, UDP  
• Передача и прием пакетов, содержащих типы (Integer, float, string)  
• Возможность создания комбинированных пакетов  
• Организация сервера  
• Организация клиента  
  
**Камеры:**  
• Обычная (подходит для любых целей)  
• FPS (подходит для для шутеров)  
• Maya (подходит для для редакторов)  
• TPS (подходит для для RPG-игр)  
• RTS (подходит для для стратегий)  
• Настройка стандартных опций камеры  
  
**Устройства ввода:**  
• Все стандартные функции для работы с клавиатурой (до 169 клавиш)  
• Все стандартные функции для работы с мышью (до 5 кнопок)  
• Работа с джойстиком (до 32 кнопок, до 6 осей)  
  
**Оптимизация сцены:**  
• Меш в режиме Octree  
• Меш в режиме Batching  
• Удобная работа с LOD (Level of Detail)  
• Принудительное отображение текстур 16 или 32 бита  
• рендеринг огромного меша (1-2 млн. полигонов и больше) через видеокарту (оптимизация VBO)  
• "Запрос видимости" ( технология Occlusion Query)  
• менеджер зон видимости  
  
**Математика:**  
• встроенные функции для работы с векторами  
• встроенные функции для работы числами  
• набор функций преобразования типов (раздел wUtil)  
  
**Работа с XML:**  
• Чтение xml-файлов  
• Запись xml-файлов  
• Возможно написание своих функций парсинга xml-файлов и любых текстовых форматов  
  
**Форматы моделей:**  
  
С анимацией:  
• B3D (.b3d, скелетная)  
• Microsoft DirectX (.x, бинарные и текстовые, скелетная)  
• Milkshape (.ms3d, скелетная)  
• MDL Half Life 1 (.mdl, скелетная)  
• Quake 2 models (.md2, морфинг)  
• Quake3 models (.md3, морфинг)  
  
Без анимации:  
• 3D Studio меши (.3ds)  
• Alias Wavefront Maya (.obj)  
• Lightwave объекты (.lwo)  
• COLLADA 1.4 (.xml, .dae)  
• Microsoft DirectX (.x, бинарные и текстовые)  
• Milkshape (.ms3d)  
• OGRE меши (.mesh)  
• My3DTools 3 (.my3D)  
• Pulsar LMTools (.lmts)  
• Quake 3 уровни (.bsp)  
• DeleD (.dmf)  
• FSRad oct (.oct)  
• Cartography shop 4 (.csm)  
• STL 3D файлы (.stl)  
• PLY 3D файлы (.ply)  
• Загрузка vox-моделей формата программы Magica Voxel (.vox)  
  
**Физика:**  
  
**Базовая:**  
• Проверка столкновений  
• Для столкновений используются как примитивы, так и сложные геометрические фигуры на основе любого меша  
• Проверка столкновений для взаимодействия с террейном  
• Гравитация  
• Определение точки столкновения, используя векторы, исходящие от объекта или камеры к другому объекту (рейкастинг)  
• Определение столкновения с объектом на основе координат экрана  
• Аниматор коллизии  
  
**Физика Newton:**  
• твердые тела-примитивы (куб, сфера, конус, капсула)  
• выпуклые твердые тела (Convex Hull)  
• невыпуклые твердые тела без массы (TreeMesh)  
• составные тела (Compound Objects)  
• водная поверхность (сила Архимеда)  
• взаимодействие твёрдых тел с BSP-картами  
• физика транспортных средств  
• физические сочленения (Hinge, Slider, Universal, UpVector, CorkScrew, Ball)  
• Есть возможность подключить и другие физические библиотеки, в том числе PhysX, Tokamak, Spe и Bullet.