📖 Sobre o Projeto
O Redstone Notes é um aplicativo multifuncional desenvolvido em Flutter que combina um sistema de anotações e gerenciamento de atividades com uma poderosa ferramenta de criação de mapas mentais. A principal proposta é permitir que o usuário transforme uma simples ideia em um mapa mental visual, conectando conceitos e expandindo seus pensamentos de forma gráfica e interativa.

O aplicativo foi projetado com uma arquitetura de estado centralizada e comunicação clara entre as telas, servindo como um excelente exemplo prático de gerenciamento de dados em um aplicativo Flutter.

✨ Funcionalidades Principais
Gerenciamento de Atividades (CRUD):

Crie, edite e delete anotações/atividades com título, texto e data de conclusão.

Marque atividades como "Concluídas" e visualize-as separadamente das pendentes.

Mapas Mentais Interativos:

Transforme qualquer anotação em um mapa mental visual.

Adicione, edite e delete nós (tópicos) de forma hierárquica a partir de um nó central.

Personalize cada nó com cores e formatos diferentes (retângulo, círculo, nuvem, losango).

Navegue pelo mapa com controles de zoom e panorâmica (InteractiveViewer).

Persistência de Dados do Mapa Mental:

O estado completo de cada mapa mental (nós, propriedades e conexões) é salvo junto com a anotação principal.

A estrutura do grafo é serializada para o formato JSON e armazenada no modelo da ideia, garantindo que o mapa seja recarregado exatamente como foi deixado.

Interface Moderna:

Navegação principal com BottomNavigationBar e PageView para alternar entre a lista de atividades e a seleção de mapas mentais.

Suporte a Tema Escuro (Dark Mode), com a preferência do usuário salva no dispositivo.

🏗️ Arquitetura e Conceitos Aplicados
Gerenciamento de Estado Centralizado: A HomeScreen atua como a "fonte única da verdade", gerenciando a lista principal de ideias. As alterações feitas em outras telas são comunicadas de volta para a HomeScreen através de funções de callback, garantindo um fluxo de dados consistente.

Modelagem de Dados: O projeto utiliza classes bem definidas para representar os dados:

Ideia: Representa a anotação principal, contendo título, texto, status e os dados serializados do mapa mental.

MindMapNodeData: Representa um único nó no mapa mental, com suas propriedades visuais (cor, formato) e um ID único.

Navegação e Fluxo de Dados: A navegação entre as telas (Navigator) é utilizada para passar dados (como ao editar uma ideia) e para retornar resultados (como ao salvar uma nova ideia ou um mapa mental atualizado).

Serialização JSON: A conversão da estrutura do grafo para uma string JSON (usando dart:convert) é a chave para a persistência dos mapas mentais.

🛠️ Tecnologias e Pacotes Utilizados
Flutter: Framework principal para o desenvolvimento da UI multiplataforma.

provider: Utilizado para o gerenciamento de estado do tema (claro/escuro).

graphview: Pacote fundamental para a renderização e organização dos nós do mapa mental em uma estrutura de grafo.

uuid: Para a geração de identificadores únicos para cada Ideia e cada nó do mapa, garantindo a integridade dos dados.

intl: Utilizado para formatar as datas das atividades de forma legível.

shared_preferences: Para salvar localmente a preferência de tema do usuário.

🚀 Como Executar o Projeto
Siga os passos abaixo para executar o projeto localmente.

Pré-requisitos
Você precisa ter o SDK do Flutter instalado e configurado corretamente no seu ambiente.

Um emulador Android/iOS configurado ou um dispositivo físico conectado.