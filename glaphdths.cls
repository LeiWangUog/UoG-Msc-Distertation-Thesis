%%
%% glaphdths.cls - LaTeX2e thesis class
%%
%% Copyright (C) 1998 George Taylor
%% Copyright (C) 2002 Mike Nolta <mrnolta@princeton.edu>
%% Copyright (C) 2010-2021 Mathew Topper <damm_horse@yahoo.co.uk>
%% Copyright (C) 2022 Cristina Chueca Del Cerro 
%%
%%   ABOUT
%%
%% This is the class file for a Latex2e template which corresponds to the
%% regulations regarding layout of a thesis submitted within the University of Glasgow.
% Wrapper to call commands to start the main body text.
\newcommand{\startbody}{%
    \cleardoublepage%
    \pagenumbering{arabic}%

    %% Use alternative style if twosideflag is true
    \ifthenelse{\boolean{twosideflag}}%
      {\pagestyle{twomain}}%
      {\pagestyle{main}}%
    }

%% BEGIN CLASS FILE
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{glaphdths}[20/10/2022 University of Glasgow Politics thesis class]

%% LOAD PACKAGES REQUIRED FOR CLASS

%% `ifthen' provides simple boolean commands
\RequirePackage{ifthen}

%% 'ifpdf' detects whether pdflatex is being used.
\RequirePackage{ifpdf}

%% Calc package is needed for titlepage length calculation
\RequirePackage{calc}

%% DECLARE VARIABLES AND COMMANDS FOR CLASS

%% Define a command to switch between report and rapport3 classes.
%% 'rapport3' class does brutalist spacing, but the bibspacing needs
%% manually controlled as it sets this to zero.
\newcommand{\classfile}{report}

%% Define an option warning to print when unwanted options are given
\newcommand{\OptionWarning}[1]{\ClassWarning{glaphdths}{Option '#1' not available for glaphdths.}}

%% Define a command to declare the unused options in the report class, giving
%% a warning in the output.
\newcommand{\OffOption}[1]{\DeclareOption{#1}{\OptionNotUsed\OptionWarning{#1}}}

%% Define a command to declare the available options in the report class.
\newcommand{\OnOption}[1]{%
               \DeclareOption{#1}{\PassOptionsToClass{#1}{\classfile}}}

%% Make some booleans for special package options
\newboolean{sansflag}                   % Default is for sans serif fonts for 
\setboolean{sansflag}{true}             % captions and headers

\newboolean{msfontsflag}                % Use MS fonts
\setboolean{msfontsflag}{false}

\newboolean{fancychapflag}              % Use fancy chapter headerings
\setboolean{fancychapflag}{false}

\newboolean{crestflag}                  % Put a crest on the frontpage
\setboolean{crestflag}{false}

\newboolean{labelflag}                  % Print labels on the page
\setboolean{labelflag}{false}

\newboolean{twosideflag}                % Is the twoside option set?
\setboolean{twosideflag}{false}

\newboolean{hyperflag}
\setboolean{hyperflag}{false}           % Use hyperref package?

\newboolean{nomenclflag}
\setboolean{nomenclflag}{false}        % Use nomencl package?


%%%% DECLARE OPTIONS

%% LOCAL OPTIONS

%% Enable numbering of subsubsections (note: these don't appear in the contents)
\DeclareOption{subsubnos}{\addtocounter{secnumdepth}{1}}

%% Don't use the sans serif headers and captions
\DeclareOption{nosans}{\setboolean{sansflag}{false}}

%% Remove paragraph indent and add a line skip by switch class to rapport3
\DeclareOption{nopardent}{\renewcommand{\classfile}{rapport3}}

%% Use MS fonts rather than latex default
\DeclareOption{msfonts}{\setboolean{msfontsflag}{true}}

%% Use fancy chapter headings like jthesis-v1
\DeclareOption{fancychap}{\setboolean{fancychapflag}{true}}

%% Use a crest on the front page
\DeclareOption{crest}{\setboolean{crestflag}{true}}

%% Print equation labels next to equation numbers.
\DeclareOption{labels}{\setboolean{labelflag}{true}}

%% Use hyperref
\DeclareOption{hyper}{\setboolean{hyperflag}{true}}

%% Use nomencl
\DeclareOption{nomencl}{\setboolean{nomenclflag}{true}}

%% Must have options.
\OnOption{a4paper}
\OnOption{openright}     % Start chapters on righthand side pages
\OnOption{titlepage}     % Title should be on it's own page.

%% Alternative options for the report class 
\OnOption{10pt}
\OnOption{11pt}
\OnOption{12pt}
\OnOption{draft}
\OnOption{final}
\OnOption{fleqno}
\OnOption{leqno}
\OnOption{oneside}

%% Set a boolean in addition for the twoside option
\DeclareOption{twoside}{\setboolean{twosideflag}{true}%
                        \PassOptionsToClass{twoside}{\classfile}}

%% Switch off `report' options that won't be allowed.
\OffOption{letterpaper}
\OffOption{legalpaper}
\OffOption{executivepaper}
\OffOption{a5paper}
\OffOption{b5paper}
\OffOption{landscape}
\OffOption{twocolumn}
\OffOption{notitlepage}
\OffOption{openany}
\OffOption{openbib}

%% OTHER OPTIONS

%% Pass a warning for any options that are not known at this stage
\DeclareOption*{\OptionWarning{\CurrentOption}}

%% PROCESS OPTIONS
\ProcessOptions\relax

%% Load report class with default setup
\LoadClass[a4paper,openright,titlepage]{\classfile}

%% COLORS FIRST

%% xcolor should be loaded prior to the user inputted packages or stuff like
%% pstricks will not work apparently. xcolor gives better color match for
%% hyperlinks.
\ifthenelse{\boolean{pdf}}{%
    \newcommand{\colordriver}{pdftex}
    }{%
    \newcommand{\colordriver}{xdvi, dvipdfmx}
    }
\ifthenelse{\boolean{hyperflag}}{%
    \RequirePackage[\colordriver, dvipsnames, hyperref]{xcolor}%
   }{
    \RequirePackage[\colordriver, dvipsnames]{xcolor}%
   }

%%%% INPUT THE USER DEFINED PACKAGES (Loading here allows options to be passed
%%%%                                  to the auto loaded packages)

\InputIfFileExists{packages.tex}{\typeout{Succesful input of user packages.}}%
                                {\typeout{No user packages.tex file found.}}

%%%% LOAD MAIN PACKAGES

\RequirePackage{graphicx}		        % Allows inclusion of graphics
						% in eps or jpg/pdf format

%% General formatting specified in format.tex
\RequirePackage[includehead]{geometry}          % A more modern way of setting 
                                                % the page margins.
                                                % Report options are passed
                                                % automatically.
\RequirePackage{setspace}        % Define line spacing

%% Appendix
\RequirePackage{appendix}                       % Required for appendices

%% FONTS 
\RequirePackage{ae}                             % Virtual fonts for T1 encoded
                                                % CMR-fonts.
\RequirePackage[T2A,T1]{fontenc}                % T1 encoding stops some errors
                                                % for unknown fonts

\ifthenelse{\boolean{msfontsflag}}{%            % Use MS fonts if the option is
  \RequirePackage{mathptmx}%  
  \RequirePackage{fontspec}%
  \RequirePackage[scaled=.92]{helvet}%
  
  }{%
  }
  
%% Provide the font options to packages for the sans serif fonts
%% This loads caption and subcaption. Caption does caption formatting and
%% subcaption allows subfigures.
\ifthenelse{\boolean{sansflag}}{%
    \RequirePackage[subfigure]{tocloft}%
    \RequirePackage[labelfont={sf,bf}, textfont=sf]{caption, subfig}

%
  }{%
  \RequirePackage[subfigure]{tocloft}%
   \RequirePackage[labelfont=bf]{caption, subfig}%
  }

%% TITLES AND CAPTIONS

%% Titlesec does headers and title formating. The definitions for the chapter
%% headers are set below
\RequirePackage[nobottomtitles*,pagestyles,clearempty]{titlesec}%

%% Allow modifications to the able of contents and lists
%\RequirePackage[titles]{tocloft}%

%% NOMENCLATURE

%% Load the nomencl package. More work done on it lower down.
\ifthenelse{\boolean{nomenclflag}}{%
   \RequirePackage{nomencl}%
   \makenomenclature%
}{%
  % If nomencl is not loaded redefine printglossary to avoid errors.
  \def\printnomenclature{}%
}

%% HYPERLINKS

\ifthenelse{\boolean{pdf}}{%
    \newcommand{\hyperdriver}{pdftex}%
    \RequirePackage[pdftex]{hyperref}
    }{%
    \RequirePackage[xetex]{hyperref}
}

%% LABELS

%% Print labels on the page if option is given
\ifthenelse{\boolean{labelflag}}{%
   \AtEndOfClass{\RequirePackage[inner]{showlabels}}%
}{}


%%%% MORE PACKAGES CAN BE DEFINED IN packages.tex

%%%% FORMAT DEFINITIONS.

%% FONTS
\setmainfont{Latin Modern Roman}
%% PARTS

%% There is a particular issue with hyperef and the part definition which can be
%% fixed as follows:
\ifthenelse{\boolean{hyperflag}}{%
  \AtBeginDocument{%
    \pdfstringdefDisableCommands{%
      \let\MakeUppercase\relax%
    \typeout{Disabled uppercase in PDF strings}%
    } 
  }}{}

%% Standardise the part definitions
\titleformat{\part}[display]
   {\Huge \filcenter}
   {\MakeUppercase{\partname{} \thepart}}
   {0em}
   {}

%% The following code is recommended, but doesn't work. See:
%% http://tex.stackexchange.com/questions/6609/problems-with-part-labels-using-titlesec

% \makeatletter
% \let\titlesec@part\part
% \renewcommand{\part}{\@ifstar\part@star\part@nostar}
% \def\part@star#1{\NR@gettitle{#1}\titlesec@part*{#1}}
% \def\part@nostar{\@ifnextchar[\part@nostar@opt\part@nostar@nopt}
% \def\part@nostar@nopt#1{\NR@gettitle{#1}\titlesec@part{#1}}
% \def\part@nostar@opt[#1]#2{\NR@gettitle{#2}\titlesec@part[#1]{#2}}
% \makeatother

%% MAIN CHAPTER HEADINGS

%% These are produced using the titlesec package.

%% Check for fancychap flag and change chapter default if true
\ifthenelse{\boolean{fancychapflag}}{%
  \titleformat{\chapter}[display]%
    {\huge\normalfont \filleft\onehalfspacing%
   % \titlerule[0pt]%
    \vspace{1pt}}%
    %\titlerule}%
    {%
    \vspace{1ex}%
    \chaptertitlename \space \thechapter}%
    {0.5ex}%
    {\bfseries\Huge}%
    [\vspace{1ex}%
    ]%
    %% Control the spacing of the numbered chapters.
    \titlespacing*{\chapter}{0pt}{0pt}{30pt}
    \titleformat{name=\chapter,numberless}[display]%
    {\huge\normalfont \filcenter}%
    %% Move the title to the top of the page
    {\vspace{-6ex}}%
    {0pt}%
    {\titlerule[0pt]}%
    [\vspace{\parskip}%
    ]
    %% Control the spacing of the un-numbered chapters.
    \titlespacing*{name=\chapter,numberless}{0pt}{0pt}{30pt}%
    }%
  {%% Fix chapter spacing to one and a half
    \titleformat{\chapter}[display]%
    {\huge\normalfont \bfseries\onehalfspacing}%
    {\chaptertitlename\ \thechapter}%
    {20pt}%
    {\Huge}%
  }

%% FRONT MATTER CHAPTER HEADINGS

%% Design some chapter headings for centred headings in the front matter like
%% the dmathesis style thesis. These are applied to the front matter using
%% a wrapper enviroment. Also kill the chapter numbers from \chapter, but still
%% add a TOC entry. - Adapted from Mathew Topper's code.

\newenvironment{precontent}
  {%% No chapter number, but still TOC entry.
   \setcounter{secnumdepth}{-1}%
   \renewcommand{\chaptermark}[1]{}%
   \pagestyle{plain}%
   \titlespacing*{\chapter}{0pt}{0pt}{30pt}%
   \ifthenelse{\boolean{fancychapflag}}{%
      %% 'numberless' definition above is sufficient.
    }{%
      %% Redifine the chapters to center.
      \titleformat{\chapter}[display]%
      {\normalfont \bfseries\filcenter}%
      {\chaptertitlename \thechapter}%
      {20pt}%
      {\Huge}%
   }}%
  {
   %% Restart numbering
   \setcounter{secnumdepth}{4}%
  }

%% SECTIONS

%% Protect the section definitions from the rapport3 class as
%% it does some weird alignment to them.
\titleformat{\section}
  {\normalfont \Large\bfseries}{\thesection}{1em}{}
\titleformat{\subsection}
  {\normalfont \large\bfseries}{\thesubsection}{1em}{}
\titleformat{\subsubsection}
  {\normalfont \large\bfseries}{\thesubsubsection}{1em}{}


%%%% SINGLE SPACING QUOTE ENVIRONMENTS

\let\oldquote=\quote
\let\endoldquote=\endquote
\renewenvironment{quote}{%
    \begin{oldquote}%
    \begin{singlespace}%
  }{%
    \end{singlespace}%
    \end{oldquote}%
  }
\let\oldquotation=\quotation
\let\endoldquotation=\endquotation
\renewenvironment{quotation}{%
    \begin{oldquotation}%
    \begin{singlespace}%
  }{%
    \end{singlespace}%
    \end{oldquotation}%
  }






%% ABSTRACT

% 添加 Abstract 到目录
\newcommand{\addabstracttocontents}{
    \addcontentsline{toc}{chapter}{\protect\numberline{\Roman{chapter}}Abstract}
}








%%% default declaration unless stated otherwise 
\newcommand{\standarddeclaration}[1]{%
  % Set up a box for the author name
  \newsavebox{\mybox}%
  \sbox{\mybox}{\bfseries{#1}}%
  % Now measure its length
  \newlength{\myboxlen}%
  \settowidth{\myboxlen}{\usebox{\mybox}}%
  \chapter{Declaration}%
  %
  \vspace{-3em}
  I declare that, except where explicit reference is made to the contribution of others, that this dissertation is the result of my own work and has not been submitted for any other degree at the University of Glasgow or any other institution 

  \vfill
  %
  % Add a line with the authors name underneath.
  % The line should not be less than 0.4/textwidth
  \noindent%
  \ifthenelse{\lengthtest{ \myboxlen < 0.4\textwidth }}{%
       \rule{0.4\textwidth}{.01in}\\}{%
       \rule{\myboxlen}{.01in}\\%
       }%
  %
  \usebox{\mybox}\\%
  %
  \vspace*{5cm}%
}


%% REDEFINE LOF AND LOT TO ADD LINE TO TOC

%% Maually add a line to the contents with phantomsection
%% to make better links if hyperref is used.
\let\oldlistoffigures\listoffigures
\renewcommand{\listoffigures}{
    \cleardoublepage
    \phantomsection
    \addcontentsline{toc}{chapter}{\listfigurename}
    \oldlistoffigures
}

\let\oldlistoftables\listoftables
\renewcommand{\listoftables}{
    \cleardoublepage
    \phantomsection
    \addcontentsline{toc}{chapter}{\listtablename}
    \oldlistoftables
}

%% ADD A FRONT MATTER CHAPTER COMMAND.
%% STARRED VERSION HAS NO TOC ENTRY.

%% Allow internal use of @ symbol
\makeatletter

\newcommand{\frontchapter}{\@ifstar
                     \frontchapterStar%
                     \frontchapterNoStar%
}

\newcommand{\frontchapterStar}[1]{%
    \cleardoublepage%
    \phantomsection%
    \chapter*{{#1}%
             \@mkboth{\MakeUppercase{#1}}%
                     {\MakeUppercase{#1}}%
             }%
    }

\newcommand{\frontchapterNoStar}[1]{%
    \cleardoublepage%
    \phantomsection%
    \addcontentsline{toc}{chapter}{#1}%
    \chapter*{{#1}%
             \@mkboth{\MakeUppercase{#1}}%
                     {\MakeUppercase{#1}}%
             }%
    }

%% Make at safe again.
\makeatother

%% DEFINITION OF A COMBINED FIGURE AND TABLE LIST

%% Make a name for it.
\newcommand{\listfiguretablename}{Figures and Tables}

%% Allow internal use of @ symbol
\makeatletter

\newcommand\listoffiguresandtables{%
    \if@twocolumn%
      \@restonecoltrue\onecolumn%
    \else%
      \@restonecolfalse%
    \fi%
    \frontchapter{\listfiguretablename}%
    \section*{Figures}%
     {\@starttoc{lof}}%
    \mrule%
    \section*{Tables}%
     {\@starttoc{lot}}%
    \if@restonecol\twocolumn\fi%%
    }

%% Make at safe again.
\makeatother

%% FIX THE NOMENCLATURE TITLE IF THE PACKAGE IS BEING USED.

%% Allow internal use of @ symbol
\makeatletter

\ifthenelse{\boolean{nomenclflag}}{%
  %% Redefine \theglossary command
  \renewcommand{\thenomenclature}{%
    \frontchapter{\nomname}%
    \nompreamble
    \list{}{%
      \labelwidth\nom@tempdim
      \leftmargin\labelwidth
      \advance\leftmargin\labelsep
      \itemsep\nomitemsep
      \let\makelabel\nomlabel}}%
}{}

%% Make at safe again.
\makeatother

%% DEFINE BIBLIOGRAPHY HYPHENATION PENALTY
\let\bibhyphenpenalty\hyphenpenalty

%% DEFINE BIBLIOGRAPHY TO ADD LINE TO TOC AND SET
%% HYPHENPENTALTY

%% Maually add a line to the contents with phantomsection
%% to make better links if hyperref is used.
% \newcommand{\edbibliography}{%
%     \cleardoublepage%
%     \phantomsection%
%     \addcontentsline{toc}{chapter}{\bibname}%
%     \message{Bibliography hyphenation penalty: \the\bibhyphenpenalty}%
%     \hyphenpenalty=\bibhyphenpenalty%
%     \bibliography
% }

%% SHORTCUT WRAPPERS

%% Wrapper to produce the front matter in one go.
\newcommand{\makeprecontent}[1]{%
    %% Start the page numbering in roman
    \pagenumbering{roman}%

    %% Make the title page
    \maketitle%
    \cleardoublepage%
    \begin{precontent}%
       \input{#1}%
    \end{precontent}
    %% Make sure declaration has right page style
    %% and page numbering is sane.
    \cleardoublepage
    %% Use alternative style if twosideflag is true
    \ifthenelse{\boolean{twosideflag}}%
      {\pagestyle{twomain}}%
      {\pagestyle{main}}%
    }

%% Wrapper to call commands to start the main body text.
\newcommand{\startbody}{%
    \cleardoublepage%
    \pagenumbering{arabic}%

    %% Use alternative style if twosideflag is true
    \ifthenelse{\boolean{twosideflag}}%
      {\pagestyle{twomain}}%
      {\pagestyle{main}}%
    }


%%%% OTHER STUFF

%% Define new counter so you can have the equation
%% number 4.2.1a for example, this a gift from J.F.Blowey
%% Usage \eqlabon to start a,b numbering and \eqlaboff
%% to stop.

\newcounter{ind}
\newcommand{\eqlabon}{%
  \setcounter{ind}{\value{equation}}\addtocounter{ind}{1}%
  \setcounter{equation}{0}%
  \renewcommand{\theequation}{\arabic{chapter}%
          .\arabic{section}.\arabic{ind}\alph{equation}}}

\newcommand{\eqlaboff}{%
  \renewcommand{\theequation}{\arabic{chapter}%
          .\arabic{section}.\arabic{equation}}%
  \setcounter{equation}{\value{ind}}}

%% Thick horizontal line.
\newcommand{\HRule}{\rule{\linewidth}{0.5mm}}

%% Short centred horizontal line.
\newcommand{\mrule}{%
   \begin{center}%
    \rule{0.5\linewidth}{0.2mm}%
   \end{center}}

%%%% INPUT THE USER DEFINED FORMATTING FILE

\AtEndOfClass{%
\InputIfFileExists{glasgowfmt.tex}{\typeout{Succesful input of formatting file.}}%
                                {\ClassError{glaphdths}{%
                                 Formatting file not found!%
                                }{%
                                 Oh dear! Something's gone wrong. \MessageBreak%
                                 Where is glasgowfmt.tex? I need it!}}%
}
