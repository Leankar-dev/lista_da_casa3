# 🛒 ListaDaCasa

**App de Lista de Compras** desenvolvido em Flutter com design Neumórfico.

> Desenvolvido por **Leankar.dev**

---

## 📱 Sobre o Projeto

ListaDaCasa é uma aplicação móvel para gestão de listas de compras, permitindo organizar itens por categorias, acompanhar gastos e manter um histórico completo das suas compras.

### ✨ Funcionalidades

- **Lista de Compras**
  - Adicionar, editar e eliminar itens
  - Marcar itens como comprados
  - Organização por categorias (Frutas, Legumes, Lacticínios, etc.)
  - Cálculo automático do total
  - Barra de progresso visual

- **Histórico de Compras**
  - Registo de todas as compras finalizadas
  - Visualização por data e mercado
  - Edição e eliminação de registos
  - Detalhes completos de cada compra

- **Gestão de Mercados**
  - Cadastro de mercados frequentes
  - Associação de compras a mercados
  - Adicionar mercados durante finalização

- **Gráficos e Estatísticas**
  - Evolução dos gastos mensais
  - Distribuição por categoria
  - Total gasto acumulado

- **Sincronização na Nuvem**
  - Autenticação com Google (Firebase)
  - Backup dos dados na cloud
  - Sincronização entre dispositivos

---

## 🎨 Design

O app utiliza **design Neumórfico** (Soft UI), com:
- Paleta de cores suaves
- Sombras sutis para efeito 3D
- Interface limpa e moderna
- Animações fluidas

---

## 🛠️ Tecnologias

| Tecnologia | Utilização |
|------------|------------|
| **Flutter 3.10+** | Framework principal |
| **Dart** | Linguagem de programação |
| **Riverpod** | Gestão de estado |
| **Drift (SQLite)** | Base de dados local |
| **Firebase Auth** | Autenticação |
| **Cloud Firestore** | Sincronização cloud |
| **FL Chart** | Gráficos |
| **Flutter Neumorphic Plus** | Componentes UI |

---

## 📁 Estrutura do Projeto

```
lib/
├── app/                    # Configuração da app
│   └── config/
├── core/                   # Núcleo partilhado
│   ├── constants/          # Cores, strings, constantes
│   ├── di/                 # Injeção de dependências
│   └── utils/              # Utilitários e extensões
├── data/                   # Camada de dados
│   ├── database/           # Drift (SQLite)
│   ├── models/             # Modelos de dados
│   ├── repositories/       # Implementação dos repositórios
│   └── services/           # Serviços Firebase
├── domain/                 # Camada de domínio
│   ├── entities/           # Entidades de negócio
│   └── repositories/       # Interfaces dos repositórios
└── presentation/           # Camada de apresentação
    ├── viewmodels/         # ViewModels (Riverpod)
    ├── views/              # Ecrãs da aplicação
    └── widgets/            # Widgets reutilizáveis
```

---

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK 3.10+
- Dart SDK 3.0+
- Android Studio / VS Code
- Firebase CLI (para configurar Firebase)

### Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/seu-usuario/lista_da_casa.git
   cd lista_da_casa
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Gere os ficheiros do Drift**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Execute a aplicação**
   ```bash
   flutter run
   ```

---

## 📦 Dependências Principais

```yaml
dependencies:
  flutter_riverpod: ^2.6.1      # Gestão de estado
  drift: ^2.22.1                # Base de dados SQLite
  firebase_core: ^3.8.1         # Firebase
  firebase_auth: ^5.3.4         # Autenticação
  cloud_firestore: ^5.5.1       # Firestore
  flutter_neumorphic_plus: ^3.3.0  # UI Neumórfica
  fl_chart: ^0.70.2             # Gráficos
  flutter_animate: ^4.5.2       # Animações
```

---

## 🌍 Idioma

A aplicação está totalmente em **Português (Portugal)**, incluindo:
- Interface do utilizador
- Categorias de produtos
- Mensagens e notificações
- Formatação de moeda (€)

---

## 📄 Licença

Este projeto é de uso privado.

---

## 👨‍💻 Desenvolvedor

**Leankar.dev**

---

*Feito com ❤️ e Flutter*
