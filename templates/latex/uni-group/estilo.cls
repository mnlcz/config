\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{estilo}
\LoadClass[10pt]{article}
\RequirePackage{hyperref}
\RequirePackage{verbatim}
\RequirePackage{attachfile2}
\RequirePackage{etoolbox}
\RequirePackage{xparse}
\RequirePackage{pgffor}
\RequirePackage{arrayjobx}
\RequirePackage{graphicx}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage[document]{ragged2e}
\RequirePackage{lipsum}
\RequirePackage{translations}
\RequirePackage{ifthen}
\RequirePackage{xstring}
\RequirePackage[a4paper, left=30mm, right=30mm, top=30mm, bottom=30mm, marginpar=25mm]{geometry}
\RequirePackage[utf8]{inputenc}
\RequirePackage{csquotes}
\RequirePackage{tikz}
\RequirePackage{xfp}
%------------------------------------------------------------------------------
%   Definiciones
%------------------------------------------------------------------------------
\newcommand{\Titulo}{TITULO}
\newcommand{\Materia}{MATERIA}
\newcommand{\Docente}{DOCENTE}

% New commands for authors and emails
\newcommand{\AutorUno}{AUTOR1}
\newcommand{\EmailUno}{email1@dominio.com}
\newcommand{\AutorDos}{AUTOR2}
\newcommand{\EmailDos}{email2@dominio.com}
% Add more if you have more authors
% \newcommand{\AutorTres}{AUTOR3}
% \newcommand{\EmailTres}{email3@dominio.com}

%------------------------------------------------------------------------------
%	Función para contar palabras
%------------------------------------------------------------------------------
\newcommand{\quickwordcount}[1]{%
  \immediate\write18{texcount -total -sum -1 -merge #1.tex > #1-words}%
  \input{#1-words} palabras%
}
%------------------------------------------------------------------------------
%	HEADERS, FOOTERS EN SECCIONES
%------------------------------------------------------------------------------
\pagestyle{fancy}
\setlength{\headheight}{37pt}
\renewcommand{\headrulewidth}{1pt}
\renewcommand{\footrulewidth}{1pt}
\rhead{\footnotesize \textsc {\Titulo \\ \Materia}} % Trabajo práctico
\lhead{\includegraphics[width=1.5cm]{img/undav.png}}
\cfoot{\small \textsc {Página \thepage\ de \pageref*{LastPage}}}
\fancypagestyle{firststyle}
 {
  \fancyhf{}
   \renewcommand{\headrulewidth}{0pt}
   % descomentar si les interesa poner la cantidad de palabras:
   %\lfoot{\textit {\quickwordcount{main}}} 
   %\rfoot{\small \textsc {Página \thepage\ de \pageref*{LastPage}}}
 }
%------------------------------------------------------------------------------
%	CARÁTULA
%------------------------------------------------------------------------------
\renewcommand*{\maketitle}{
\thispagestyle{firststyle}
\begin{titlepage}
    \centering
    {\includegraphics[width=0.5\textwidth]{./img/undav.png}\par}
    \vspace{1cm}
    {\bfseries\LARGE Ingeniería Informática \par}
    \vspace{3cm}
    {\scshape\Huge \Materia \par}
    \vspace{3cm}
    {\itshape\Large \Titulo \par}
    \vfill
    {\Large Autores: \par}
    {\Large \AutorUno ~(\href{mailto:\EmailUno}{\EmailUno}) \par}
    {\Large \AutorDos ~(\href{mailto:\EmailDos}{\EmailDos}) \par}
    % Add more authors if needed:
    % {\Large \AutorTres ~(\href{mailto:\EmailTres}{\EmailTres}) \par}
    \vfill
    {\Large Docente: \par}
    {\Large \Docente \par}
\end{titlepage}
}

