# O que tem pra hoje?

A proposta do aplicativo é disponibilizar de forma simples uma lista de tarefas para o dia atual, de forma que o usuário possa visualizar a agenda programada no dia anterior com as tarefas mais importantes os diferentes momentos do dia. Os usuários podem adicionar novas tarefas apenas para o dia seguinte.



## Configuração e Execução

Siga as instruções abaixo para configurar e executar o projeto em seu ambiente local.

### Pré-requisitos

Para rodar o projeto, é necessário a configuração no Firebase para o processo de autenticação. Basta seguir os passos da plataforma e baixar o arquivo `google-services.json` na pasta `android/app/`.

- Firebase: [Configurar APP](https://console.firebase.google.com/)
- Flutter SDK: [Baixe aqui](https://flutter.dev/)
- Git: [Baixe aqui](https://git-scm.com/)


### Passo 1: Clone o repositório
Clone o repositório para o seu diretório local usando o seguinte comando:

```bash
git clone https://github.com/seu-usuario/nome-do-projeto.git
```

### Passo 2: Verifique a configuração do Flutter
Verifique se o Flutter está configurado corretamente em seu sistema executando o seguinte comando:

```bash 
flutter doctor 
``` 

### Passo 3: Obtenha as dependências do projeto
Execute o seguinte comando para baixar todas as dependências do projeto:

```bash 
flutter pub get
``` 

### Passo 4: Configuração do emulador/dispositivo
Configure um emulador Android ou iOS ou conecte um dispositivo físico ao seu computador.

- Emulador Android: Abra o Android Studio, vá para AVD Manager e configure um novo dispositivo virtual ou inicie um dispositivo existente.
- iOS Simulator: Abra o Xcode, vá para a janela "Devices and Simulators" e adicione um novo simulador ou use um existente.

### Passo 5: Execute o aplicativo
Verifique se o Flutter reconhece o seu dispositivo ou emulador executando o seguinte comando:

```bash 
flutter devices
``` 

Em seguida, execute o aplicativo usando o seguinte comando:

```bash 
flutter run --debug
``` 

Se você tiver vários dispositivos ou emuladores conectados, especifique o dispositivo com o parâmetro `-d <device_id>`. Por exemplo: `flutter run -d Nexus_5X_API_28` para iniciar o aplicativo em um emulador específico.

Após executar esses passos, o aplicativo será compilado e executado no seu emulador ou dispositivo selecionado.

### Passo 7: Execute os testes

Para executar os testes do projeto, utilize o seguinte comando:
```bash 
flutter test
``` 

---

Existe uma APK disponível do projeto em `dist/android` com a última versão do aplicativo para instalação rápida.