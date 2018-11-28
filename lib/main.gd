############################################################################
##
##
#W  main.gd              JupyterViz Package                  Nathan Carter
##
##  Declaration file for functions of the JupyterViz package.
##
#Y  Copyright (C) 2018 University of St. Andrews, North Haugh,
#Y                     St. Andrews, Fife KY16 9SS, Scotland
##

#! @Chapter Function reference

#! @Section High-Level Public API

#! @Arguments various
#! @Returns an object that, if rendered in a Jupyter notebook, will produce a plot
#! @Description
#!  If evaluated in a Jupyter notebook, the result of this function, when
#!  rendered by that notebook, will run JavaScript code that generates and
#!  shows a plot, which could be any of a wide variety of data
#!  visualizations, including bar charts, pie charts, scatterplots, etc.
#!  (To draw a vertex-and-edge graph, see <Ref Func="PlotGraph"/> instead.)
#!  <P/>
#!  This function can take data in a wide variety of input formats.  Here is
#!  the current list of acceptable formats:
#!  <List>
#!    <Item>If <Code>X</Code> is a list of <Math>x</Math> values and
#!      <Code>Y</Code> is a list of <Math>y</Math> values then
#!      <Code>Plot(X,Y)</Code> plots them as ordered pairs.</Item>
#!    <Item>If <Code>X</Code> is a list of <Math>x</Math> values and
#!      <Code>f</Code> is a &GAP; function that can be applied to each
#!      <Math>x</Math> to yield a corresponding <Math>y</Math>, then
#!      <Code>Plot(X,f)</Code> computes those corresponding <Math>y</Math>
#!      values and plots everything as ordered pairs.</Item>
#!    <Item>If <Code>P</Code> is a list of <Math>(x,y)</Math> pairs then
#!      <Code>Plot(P)</Code> plots those ordered pairs.</Item>
#!    <Item>If <Code>Y</Code> is a list of <Math>y</Math> values then
#!      <Code>Plot(Y)</Code> assumes the corresponding <Math>x</Math>
#!      values are 1, 2, 3, and so on up to the length of <Code>Y</Code>.
#!      It then plots the corresponding set of ordered pairs.</Item>
#!    <Item>If <Code>f</Code> is a &GAP; function then it is assumed to
#!      take integer inputs and is evaluated on a small domain (1 through 5)
#!      of <Math>x</Math> values and the resulting <Math>(x,y)</Math> pairs
#!      are plotted.</Item>
#!    <Item>In any of the cases above, a new, last argument may be added
#!      that is a &GAP; record containing options for how to draw the plot,
#!      including the plot type, title, axes options, and more.
#!      (For details, see <Ref Var="ConvertDataSeriesForTool"/>.)</Item>
#!    <Item>If <Code>A1</Code> is a list of arguments from any of the points
#!      just listed (for example, it might be <Code>[X,f]</Code>) and so is
#!      <Code>A2</Code>, and so on through <Code>An</Code>, then
#!      <Code>Plot(A1,A2,...,An)</Code> creates a combination plot with all
#!      of the data from each of the arguments treated as a separate data
#!      series.  If the arguments contain conflicting plot options (e.g.,
#!      the first requests a line plot and the second a bar chart) then the
#!      earliest option specified takes precedence.</Item>
#!  </List>
#!  <P/>
#! @BeginLog
#! # Plot the number of small groups of order n, from n=1 to n=50:
#! Plot( [1..50], NrSmallGroups );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[width=4in]{groups-plot.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img width="500" src="groups-plot.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#! @BeginLog
#! # Plot how much Andrea has been jogging lately:
#! Plot( ["Jan","Feb","Mar"], [46,59,61],
#!       rec( title := "Andrea's Jogging", yaxis := "miles per month" ) );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[width=4in]{andrea-plot.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img width="500" src="andrea-plot.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
DeclareGlobalFunction( "Plot" );

#! @Description
#!  The <Package>JupyterViz</Package> Package has a high-level API and a
#!  low-level API.  The high-level API involves functions like
#!  <Code>Plot</Code>, which take data in a variety of convenient formats,
#!  and produce visualizations from them.  The low-level API can be used to
#!  pass JSON data structures to JavaScript visualization tools in their own
#!  native formats for rendering.  The high-level API is built on the
#!  low-level API, using key functions to do the conversion.
#!  <P/>
#!  The conversion functions for plots are stored in a global dictionary
#!  in this variable.  It is a &GAP; record mapping visualization tool
#!  names (such as plotly, etc., a complete list of which appears in Section
#!  <Ref Sect="Section_purpose"/>) to conversion functions.  Only those
#!  tools that support plotting data in the form of <Math>(x,y)</Math> pairs
#!  should be included.  (For example, tools that specialize in drawing
#!  vertex-and-edge graphs are not relevant here.)
#!  <P/>
#!  Each conversion function must behave as follows.  It expects its input
#!  object to be a single data series, which will be a &GAP; record with
#!  three fields:
#!  <List>
#!    <Item><Code>x</Code> - a list of <Math>x</Math> values for the
#!      plot</Item>
#!    <Item><Code>y</Code> - the corresponding list of <Math>y</Math> values
#!      for the same plot</Item>
#!    <Item><Code>options</Code> - another (inner) &GAP; record containing
#!      any of the following options.
#!      <List>
#!        <Item><Code>tool</Code> - the visualization tool to use to make
#!          the plot, as a string.  The default is "plotly".  The full list
#!          of tools is available in Section
#!          <Ref Sect="Section_purpose"/>.</Item>
#!        <Item><Code>type</Code> - the type of chart, as a string, the
#!          default for which is "line".  Which types are available depends
#!          on which tool you are using, though it is safe to assume that
#!          most common chart types (line, bar, pie) are supported by all
#!          tools.  Section <Ref Sect="Section_purpose"/> contains links to
#!          the documentation for each tool, so that you might see its
#!          full list of capabilities.</Item>
#!        <Item><Code>height</Code> - the height in pixels of the
#!          visualization to produce.  A sensible default is provided,
#!          which varies by tool.</Item>
#!        <Item><Code>width</Code> - the width in pixels of the
#!          visualization to produce.  If omitted, the tool usually fills
#!          the width of the Jupyter Notebook output cell.</Item>
#!        <Item><Code>title</Code> - the title to place at the top of the
#!          chart, as a string.  Can be omitted.</Item>
#!        <Item><Code>xaxis</Code> - the text to write below the
#!          <Math>x</Math> axis, as a string.  Can be omitted.</Item>
#!        <Item><Code>yaxis</Code> - the text to write to the left of the
#!          <Math>y</Math> axis, as a string.  Can be omitted.</Item>
#!      </List>
#!    </Item>
#!  </List>
#!  <P/>
#!  The output of the conversion function should be a &GAP; record amenable
#!  to conversion (using <Code>GapToJsonString</Code> from the
#!  <Package>json</Package> package) into JSON.  The format of the JSON is
#!  governed entirely by the tool that will be used to visualize it, each of
#!  which has a different data format it expects.
#!  <P/>
#!  Those who wish to install new visualization tools for plots (as
#!  discussed in Chapter
#!  <Ref Chap="Chapter_Adding_new_visualization_tools"/>) will want
#!  to install a new function in this object corresponding to the new tool.
#!  If you plan to do so, consider the source code for the existing
#!  conversion functions, which makes use of two useful convenince methods,
#!  <Ref Func="JUPVIZFetchWithDefault"/> and
#!  <Ref Func="JUPVIZFetchIfPresent"/>.  Following those examples will
#!  help keep your code consistent with existing code and as concise as
#!  possible.
DeclareGlobalVariable( "ConvertDataSeriesForTool" );

#! @Arguments various
#! @Returns an object that, if rendered in a Jupyter notebook, will show a graph
#! @Description
#!  If evaluated in a Jupyter notebook, the result of this function, when
#!  rendered by that notebook, will run JavaScript code that generates and
#!  shows a graph, not in the sense of coordinate axes, but in the sense of
#!  vertices and edges.  (To graph a function or data set on coordinate
#!  axes, use <Ref Func="Plot"/> instead.)
#!  <P/>
#!  This function can take data in a wide variety of input formats.  Here is
#!  the current list of acceptable formats:
#!  <List>
#!    <Item>If <Code>V</Code> is a list and <Code>E</Code> is a list of
#!      pairs of items from <Code>V</Code> then <Code>PlotGraph(V,E)</Code>
#!      treats them as vertex and edge sets, respectively.</Item>
#!    <Item>If <Code>V</Code> is a list and <Code>R</Code> is a &GAP;
#!      function then <Code>PlotGraph(V,R)</Code> treats <Code>V</Code> as
#!      the vertex set and calls <Code>R(v1,v2)</Code> for every pair of
#!      vertices (both forwards backwards) to test whether there is an edge
#!      between them.  It exepcts <Code>R</Code> to return
#!      boolean values.</Item>
#!    <Item>If <Code>E</Code> is a list of pairs then
#!      <Code>PlotGraph(E)</Code> treats <Code>E</Code> as a list of edges,
#!      inferring the vertex set to be any vertex mentioned in any of the
#!      edges.</Item>
#!    <Item>If <Code>M</Code> is a square matrix then
#!      <Code>PlotGraph(M)</Code> treats <Code>M</Code> as an adjacency
#!      matrix whose vertices are the integers 1 through <Math>n</Math>
#!      (the height of the matrix) and where two vertices are connected by
#!      an edge if and only if that matrix entry is positive.</Item>
#!    <Item>In any of the cases above, a new, last argument may be added
#!      that is a &GAP; record containing options for how to draw the graph,
#!      such as the tool to use.  For details on the supported options,
#!      see <Ref Var="ConvertGraphForTool"/>.</Item>
#!  </List>
#!  <P/>
#! @BeginLog
#! # Plot the subgroup lattice for a small group:
#! G := Group((1,2),(2,3));
#! PlotGraph( AllSubgroups(G), IsSubgroup );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[width=4in]{subgroup-lattice.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img width="500" src="subgroup-lattice.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
#! @BeginLog
#! # Plot a random graph on 5 vertices:
#! # (The results change from one run to the next, of course.)
#! PlotGraph( RandomMat(5,5) );
#! @EndLog
#! <Alt Only="LaTeX">
#!     \begin{center}
#!         \includegraphics[width=2in]{random-graph.png}
#!     \end{center}
#! </Alt>
#! <Alt Only="HTML"><![CDATA[<img width="250" src="random-graph.png"/>]]></Alt>
#! <Alt Not="LaTeX HTML">Resulting image not shown here.</Alt>
DeclareGlobalFunction( "PlotGraph" );

#! @Description
#!  The <Package>JupyterViz</Package> Package has a high-level API and a
#!  low-level API.  The high-level API involves functions like
#!  <Code>PlotGraph</Code>, which take data in a variety of convenient
#!  formats, and produce visualizations from them.  The low-level API can
#!  be used to pass JSON data structures to JavaScript visualization tools
#!  in their own native formats for rendering.  The high-level API is built
#!  on the low-level API, using key functions to do the conversion.
#!  <P/>
#!  The conversion functions for graphs are stored in a global dictionary
#!  in this variable.  It is a &GAP; record mapping visualization tool
#!  names (such as cytoscape, a complete list of which appears in Section
#!  <Ref Sect="Section_purpose"/>) to conversion functions.  Only those
#!  tools that support graphing vertex and edge sets should be included.
#!  (For example, tools that specialize in drawing plots of data stored as
#!  <Math>(x,y)</Math> pairs are not relevant here.)
#!  <P/>
#!  Each conversion function must behave as follows.  It expects its input
#!  object to be a single graph, which will be a &GAP; record with three
#!  fields:
#!  <List>
#!    <Item><Code>vertices</Code> - a list of vertex names for the
#!      graph.  These can be any &GAP; data structure and they will be
#!      converted to strings with <Code>PrintString</Code>.  The one
#!      exception is that you can give each vertex a position by making it
#!      a record with three entries: <Code>name</Code>, <Code>x</Code>, and
#!      <Code>y</Code>.  In this way, you can manually lay out a
#!      graph.</Item>
#!    <Item><Code>edges</Code> - a list of pairs from the
#!      <Code>vertices</Code> list, each of which represents an edge</Item>
#!    <Item><Code>options</Code> - a &GAP; record containing
#!      any of the following options.  (The underlying graph engines
#!      typically support far more options than these, but these are what
#!      this package currently exposes to the high-level API.)
#!      <List>
#!        <Item><Code>tool</Code> - the visualization tool to use to make
#!          the plot, as a string.  The default is "cytoscape".  The full
#!          list of tools is available in Section
#!          <Ref Sect="Section_purpose"/>.</Item>
#!        <Item><Code>layout</Code> - the name of the layout algorithm to
#!          use, as a string.  Permitted values vary by tool.  Currently
#!          cytoscape supports "preset" (meaning you must have specified
#!          the nodes' positions manually), "cose" (virtual-spring-based
#!          automatic layout), "random", "grid", "circle", "concentric"
#!          (multiple concentric circles), and "breadthfirst" (a
#!          hierarchy).</Item>
#!        <Item><Code>vertexwidth</Code> and <Code>vertexheight</Code> -
#!          the dimensions of each vertex.</Item>
#!        <Item><Code>vertexcolor</Code> - the color of the vertices in the
#!          graph.  This should be a string representing an HTML color,
#!          such as "#ccc" or "red".</Item>
#!        <Item><Code>edgewidth</Code> - the thickness of each edge.</Item>
#!        <Item><Code>edgecolor</Code> - the color of each edge and its
#!          corresponding arrow.  This should be a string representing an
#!          HTML color, such as "#ccc" or "red".</Item>
#!        <Item><Code>directed</Code> - a boolean defaulting to false,
#!          whether to draw arrows to visually indicate that the graph is
#!          a directed graph</Item>
#!        <Item><Code>arrowscale</Code> - a multiplier to increase or
#!          decrease the size of arrows in a directed graph.</Item>
#!        <Item><Code>height</Code> - the height in pixels of the
#!          visualization to produce.  A sensible default is provided,
#!          which varies by tool.</Item>
#!        <Item><Code>width</Code> - the width in pixels of the
#!          visualization to produce.  If omitted, the tool usually fills
#!          the width of the Jupyter Notebook output cell.</Item>
#!      </List>
#!    </Item>
#!  </List>
#!  <P/>
#!  The output of the conversion function should be a &GAP; record amenable
#!  to conversion (using <Code>GapToJsonString</Code> from the
#!  <Package>json</Package> package) into JSON.  The format of the JSON is
#!  governed entirely by the tool that will be used to visualize it, each of
#!  which has a different data format it expects.
#!  <P/>
#!  Those who wish to install new visualization tools for graphs (as
#!  discussed in Chapter
#!  <Ref Chap="Chapter_Adding_new_visualization_tools"/>) will want
#!  to install a new function in this object corresponding to the new tool.
#!  If you plan to do so, consider the source code for the existing
#!  conversion functions, which makes use of two useful convenince methods,
#!  <Ref Func="JUPVIZFetchWithDefault"/> and
#!  <Ref Func="JUPVIZFetchIfPresent"/>.  Following those examples will
#!  help keep your code consistent with existing code and as concise as
#!  possible.
DeclareGlobalVariable( "ConvertGraphForTool" );

#! @Section Low-Level Public API

#! @Arguments script
#! @Returns an object that, if rendered in a Jupyter notebook, will run <Arg>script</Arg> as JavaScript
#! @Description
#!  If evaluated in a Jupyter notebook, its result, when rendered by that
#!  notebook, will run the JavaScript code in <Arg>script</Arg>.
#!  <P/>
#!  When the given code is run, the varible <Code>element</Code> will be
#!  defined in its environment, and will contain the output element in the
#!  Jupyter notebook corresponding to the code that was just evaluated.
#!  The script is free to write to that output element.
#!  <P/>
#!  This function is not intended for use in the &GAP; REPL.
DeclareGlobalFunction( "RunJavaScript" );

#! @Arguments filename
#! @Returns the string contents of the file whose name is given
#! @Description
#!  Interprets the given <Arg>filename</Arg> relative to the
#!  <File>lib/js/</File> path in the <Package>JupyterViz</Package>
#!  package's installation folder, because that is where this package
#!  stores its JavaScript libraries.  A <File>.js</File> extension will be
#!  added to <Arg>filename</Arg> iff needed.  A <File>.min.js</File>
#!  extension will be added iff such a file exists, to prioritize minified
#!  versions of files.
#!  <P/>
#!  If the file has been loaded before in this &GAP; session, it will not be
#!  reloaded, but will be returned from a cache in memory, for efficiency.
#!  <P/>
#!  If no such file exists, returns <Keyword>fail</Keyword> and caches
#!  nothing.
DeclareGlobalFunction( "LoadJavaScriptFile" );

#! @Arguments toolName,script
#! @Returns boolean indicating success (true) or failure (false)
#! @Description
#!  This function permits extending, at runtime, the set of JavaScript
#!  visualization tools beyond those that are built into the
#!  <Package>JupyterViz</Package> package.
#!  <P/>
#!  The first argument must be the name of the visualization tool (a string,
#!  which you will later use in the <Code>tool</Code> field when calling
#!  <Ref Func="CreateVisualization"/>).  The second must be a string of
#!  JavaScript code that installs into
#!  <Code>window.VisualizationTools.TOOL_NAME_HERE</Code> the function for
#!  creating visualizations using that tool.  It can also define other
#!  helper functions or make calls to <Code>window.requirejs.config</Code>.
#!  For examples of how to write such JavaScript code, see the chapter on
#!  extending this package in its manual.
#!  <P/>
#!  This function returns false and does nothing if a tool of that name has
#!  already been installed.  Otherwise, it installs the tool and returns
#!  true.
#!  <P/>
#!  There is also a convenience method that calls this one on your behalf;
#!  see <Ref Func="InstallVisualizationToolFromTemplate"/>.
DeclareGlobalFunction( "InstallVisualizationTool" );

#! @Arguments toolName,functionBody[,CDNURL]
#! @Returns boolean indicating success (true) or failure (false)
#! @Description
#!  This function is a convenience function that makes it easier to use
#!  <Ref Func="InstallVisualizationTool"/>; see the documentation for that
#!  function, then read on below for how this function makes it easier.
#!  <P/>
#!  Most visualization tools do two things:  First, they install a CDN URL
#!  into <Code>window.requirejs.config</Code> for some external JavaScript
#!  library that must be loaded in the client to support the given type of
#!  visualization.  Second, they install a function as
#!  <Code>window.VisualizationTools.TOOL_NAME_HERE</Code> accepting
#!  parameters <Code>element</Code>, <Code>json</Code>, and
#!  <Code>callback</Code>, and building the desired visualization inside
#!  the given DOM element.  Such code often begins with a call to
#!  <Code>require(['...'],function(library}{/*...*/}))</Code>, but not
#!  always.
#!  <P/>
#!  This function will write for you the boiler plate code for calling
#!  <Code>window.requirejs.config</Code> and the declaration and
#!  installation of a function into
#!  <Code>window.VisualizationTools.TOOL_NAME_HERE</Code>.  You provide the
#!  function body and optionally the CDN URL.  (If you provide no CDN URL,
#!  then no external CDN will be installed into <Code>requirejs</Code>.)
DeclareGlobalFunction( "InstallVisualizationToolFromTemplate" );

#! @Arguments data[,code]
#! @Returns an object that, if rendered in a Jupyter notebook, will run a script to create the desired visualization
#! @Description
#!  The <Arg>data</Arg> must be a record that will be converted to JSON
#!  using &GAP;'s <Package>json</Package> package.
#!  <P/>
#!  The second argument is optional, a string containing JavaScript
#!  <Arg>code</Arg> to run once the visualization has been created.  When
#!  that code is run, the variables <Code>element</Code> and
#!  <Code>visualization</Code> will be in its environment, the former
#!  holding the output element in the notebook containing the
#!  visualization, and the latter holding the visualization element itself.
#!  <P/>
#!  The <Arg>data</Arg> should have the following attributes.
#!   * <Code>tool</Code> (required) - the name of the visualization tool to
#!     use.  Currently supported tools:
#!      * <Code>anychart</Code>, whose JSON data format is given here:<P/>
#!        <URL>https://docs.anychart.com/Working_with_Data/Data_From_JSON</URL>
#!      * <Code>canvas</Code>, that is, a regular HTML canvas element, on
#!        which you can draw using arbitrary JavaScript included in
#!        the <Arg>code</Arg> parameter
#!      * <Code>canvasjs</Code>, whose JSON data format is given here:<P/>
#!        <URL>https://canvasjs.com/docs/charts/chart-types/</URL>
#!      * <Code>chartjs</Code>, whose JSON data format is given here:<P/>
#!        <URL>http://www.chartjs.org/docs/latest/getting-started/usage.html</URL>
#!      * <Code>cytoscape</Code>, whose JSON data format is given here:<P/>
#!        <URL>http://js.cytoscape.org/#notation/elements-json</URL>
#!      * <Code>d3</Code>, which is loaded into an SVG element in the
#!        notebook's output cell, and the caller can call any D3 methods on
#!        that element thereafter, using arbitrary JavaScript included in
#!        the <Arg>code</Arg> parameter
#!      * <Code>html</Code>, which fills the output element with arbitrary
#!        HTML, which the caller should provide as a string in the
#!        <Code>html</Code> field of <Arg>data</Arg>, as documented below
#!      * <Code>plotly</Code>, whose JSON data format is given here:<P/>
#!        <URL>https://plot.ly/javascript/plotlyjs-function-reference/#plotlynewplot</URL>
#!   * <Code>data</Code> (required) - subobject containing all options
#!     specific to the content of the visualization, often passed intact to
#!     the external JavaScript visualization library.  You should prepare
#!     this data in the format required by the library specified in the
#!     <Code>tool</Code> field, following the documentation for that
#!     library cited above.
#!   * <Code>width</Code> (optional) - width to set on the output element
#!     being created
#!   * <Code>height</Code> (optional) - similar, but height
#! @BeginLog
#! CreateVisualization( rec(
#!     tool := "html",
#!     data := rec( html := "I am <i>SO</i> excited about this." )
#! ), "console.log( 'Visualization created.' );" );
#! @EndLog
DeclareGlobalFunction( "CreateVisualization" );

#! @Section Internal methods

#! Using the convention common to &GAP; packages, we prefix all methods not
#! intended for public use with a sequence of characters that indicate our
#! particular package.  In this case, we use the <Code>JUPVIZ</Code> prefix.
#! This is a sort of "poor man's namespacing."
#! <P/>
#! **None of these methods should need to be called by a client of this
#! package.  We provide this documentation here for completeness, not out of
#! necessity.**

#! @Arguments filename
#! @Returns a JavaScript filename to an absolute path in the package dir
#! @Description
#!  Given a relative <Arg>filename</Arg>, convert it into an absolute
#!  filename by prepending the path to the <File>lib/js/</File> folder
#!  within the <Package>JupyterViz</Package> package's installation
#!  folder.  This is used by functions that need to find JavaScript files
#!  stored there.
#!  <P/>
#!  A <File>.js</File> extension is appended if none is included in the
#!  given <Arg>filename</Arg>.
DeclareGlobalFunction( "JUPVIZAbsoluteJavaScriptFilename" );

#! @Description
#!  A cache of the contents of any JavaScript files that have been loaded
#!  from this package's folder.  The existence of this cache means needing
#!  to go to the filesystem for these files only once per &GAP; session.
#!  This cache is used by <Ref Func="LoadJavaScriptFile"/>.
DeclareGlobalVariable( "JUPVIZLoadedJavaScriptCache" );

#! @Arguments filename, dictionary
#! @Returns a string containing the contents of the given template file, filled in using the given dictionary
#! @Description
#!  A template file is one containing identifiers that begin with a dollar
#!  sign (<Code>\$</Code>).  For example, <Code>\$one</Code> and
#!  <Code>\$two</Code> are both identifiers.  One "fills in" the template by
#!  replacing such identifiers with whatever text the caller associates with
#!  them.
#!  <P/>
#!  This function loads the file specified by <Arg>filename</Arg> by passing
#!  that argument directly to <Ref Func="LoadJavaScriptFile"/>.  If no such
#!  file exists, returns <Keyword>fail</Keyword>.  Otherwise, it proceed as
#!  follows.
#!  <P/>
#!  For each key-value pair in the given <Arg>dictionary</Arg>, prefix a
#!  <Code>\$</Code> onto the key, suffix a newline character onto the value,
#!  and then replace all occurrences of the new key with the new value.
#!  The resulting string is the result.
#!  <P/>
#!  The newline character is included so that if any of the values in the
#!  <Arg>dictionary</Arg> contains single-line JavaScript comment characters
#!  (<Code>//</Code>) then they will not inadvertently affect later code in
#!  the template.
DeclareGlobalFunction( "JUPVIZFillInJavaScriptTemplate" );

#! @Arguments filename, dictionary
#! @Returns the composition of <Ref Func="RunJavaScript"/> with <Ref Func="JUPVIZFillInJavaScriptTemplate"/>
#! @Description
#!  This function is quite simple, and is just a convenience function
DeclareGlobalFunction( "JUPVIZRunJavaScriptFromTemplate" );

#! @Arguments jsCode
#! @Returns an object that, if rendered in a Jupyter notebook, will run <Arg>jsCode</Arg> as JavaScript after <Code>runGAP</Code> has been defined
#! @Description
#!  There is a JavaScript function called <Code>runGAP</Code>, defined in
#!  the <File>using-runGAP.js</File> file distributed with this package.
#!  That function makes it easy to make callbacks from JavaScript in a
#!  Jupyter notebook to the &GAP; kernel underneath that notebook.  This
#!  &GAP; function runs the given <Arg>jsCode</Arg> in the notebook, but
#!  only after ensuring that <Code>runGAP</Code> is defined globally in that
#!  notebook, so that <Arg>jsCode</Arg> can call <Code>runGAP</Code> as
#!  needed.
#!  <P/>
#!  Here is an example use, from JavaScript, of the <Code>runGAP</Code>
#!  function.
#! @BeginLog
#! var calculation = "2^50";
#! runGAP( calculation + ";", function ( result, error ) {
#!     if ( result )
#!         alert( calculation + "=" + result );
#!     else
#!         alert( "There was an error: " + error );
#! } );
#! @EndLog
DeclareGlobalFunction( "JUPVIZRunJavaScriptUsingRunGAP" );

#! @Arguments libraries, jsCode
#! @Returns an object that, if rendered in a Jupyter notebook, will run <Arg>jsCode</Arg> as JavaScript after all <Arg>libraries</Arg> have been loaded
#! @Description
#!  There are a set of JavaScript libraries stored in the
#!  <File>lib/js/</File> subfolder of this package's installation folder.
#!  The Jupyter notebook does not, by default, know about any of those
#!  libraries.  This &GAP; function runs the given <Arg>jsCode</Arg> in the
#!  notebook, but only after ensuring that all JavaScript files on the list
#!  <Arg>libraries</Arg> have been loaded, so that <Arg>jsCode</Arg> can
#!  make use of the functions and variables that they define.
#!  <P/>
#!  If the first parameter is given as a string instead of a list of
#!  strings, it is treated as a list of just one string.
#! @BeginLog
#! JUPVIZRunJavaScriptUsingLibraries( [ "mylib.js" ],
#!     "alert( 'My Lib defines foo to be: ' + window.foo );" );
#! # Equivalently:
#! JUPVIZRunJavaScriptUsingLibraries( "mylib.js",
#!     "alert( 'My Lib defines foo to be: ' + window.foo );" );
#! @EndLog
DeclareGlobalFunction( "JUPVIZRunJavaScriptUsingLibraries" );

#! @Arguments series
#! @Returns a record with the appropriate fields (<Code>x</Code>, <Code>y</Code>, <Code>options</Code>) that it can be passed to one of the functions in <Ref Var="ConvertDataSeriesForTool"/>
#! @Description
#!  This function is called by <Ref Func="Plot"/> to convert any of the wide
#!  variety of inputs that <Ref Func="Plot"/> might receive into a single
#!  internal format.  Then that internal format can be converted to the JSON
#!  format needed by any of the visualization tools supported by this
#!  package.
#!  <P/>
#!  See the documentation for <Ref Var="ConvertDataSeriesForTool"/> for
#!  more information on how that latter conversion takes place, and the
#!  format it expects.
DeclareGlobalFunction( "JUPVIZMakePlotDataSeries" );

#! @Arguments series1, series2, series3...
#! @Returns a <Code>JupyterRenderable</Code> object ready to be displayed in the Jupyter Notebook
#! @Description
#!  Because the <Ref Func="Plot"/> function can take a single data series or
#!  many data series as input, it detects which it received, then passes the
#!  resulting data series (as an array containing one or more series) to
#!  this function for collecting into a single plot.
#!  <P/>
#!  It is not expected that clients of this package will need to call this
#!  internal function.
DeclareGlobalFunction( "JUPVIZPlotDataSeriesList" );

#! @Arguments record, keychain, default
#! @Returns the result of looking up the chain of keys in the given record
#! @Description
#!  In nested records, such as <Code>myRec:=rec(a:=rec(b:=5))</Code>, it
#!  is common to write code such as <Code>myRec.a.b</Code> to access the
#!  internal values.  However when records are passed as parameters, and may
#!  not contain every key (as in the case when some default values should be
#!  filled in automatically), code like <Code>myRec.a.b</Code> could cause
#!  an error.  Thus we wish to first check before indexing a record that the
#!  key we're looking up exists.  If not, we wish to return the value given
#!  as the <Code>default</Code> instead.
#!  <P/>
#!  This function accepts a <Code>record</Code> (which may have other
#!  records inside it as values), an array of strings that describe a
#!  chain of keys to follow inward (<Code>["a","b"]</Code> in the example
#!  just given), and a <Code>default</Code> value to return if any of the
#!  keys do not exist.
#!  <P/>
#!  It is not expected that clients of this package will need to call this
#!  internal function.  It is used primarily to implement the
#!  <Ref Func="JUPVIZFetchWithDefault"/> function, which is useful to those
#!  who wish to extend the <Ref Var="ConvertDataSeriesForTool"/> and
#!  <Ref Var="ConvertGraphForTool"/> objects.
#!  <P/>
#! @BeginLog
#! myRec := rec( height := 50, width := 50, title := rec(
#!   text := "GAP", fontSize := 20
#! ) );
#! JUPVIZRecordKeychainLookup( myRec, [ "height" ], 10 );                # = 50
#! JUPVIZRecordKeychainLookup( myRec, [ "width" ], 10 );                 # = 50
#! JUPVIZRecordKeychainLookup( myRec, [ "depth" ], 10 );                 # = 10
#! JUPVIZRecordKeychainLookup( myRec, [ "title", "text" ], "Title" );    # = "GAP"
#! JUPVIZRecordKeychainLookup( myRec, [ "title", "color" ], "black" );   # = "black"
#! JUPVIZRecordKeychainLookup( myRec, [ "one", "two", "three" ], fail ); # = fail
#! @EndLog
DeclareGlobalFunction( "JUPVIZRecordKeychainLookup" );

#! @Arguments records, keychain, default
#! @Returns the result of looking up the chain of keys in each of the given records until a lookup succeeds
#! @Description
#!  This function is extremely similar to
#!  <Ref Func="JUPVIZRecordKeychainLookup"/> with the following difference:
#!  The first parameter is a list of records, and
#!  <Ref Func="JUPVIZRecordKeychainLookup"/> is called on each in succession
#!  with the same <Code>keychain</Code>.  If any of the lookups succeeds,
#!  then its value is returned and no further searching through the list is
#!  done.  If all of the lookups fail, the <Code>default</Code> is returned.
#!  <P/>
#!  It is not expected that clients of this package will need to call this
#!  internal function.  It is used primarily to implement the
#!  <Ref Func="JUPVIZFetchWithDefault"/> function, which is useful to those
#!  who wish to extend the <Ref Var="ConvertDataSeriesForTool"/> and
#!  <Ref Var="ConvertGraphForTool"/> objects.
#!  <P/>
#! @BeginLog
#! myRecs := [
#!   rec( height := 50, width := 50, title := rec(
#!     text := "GAP", fontSize := 20
#!   ) ),
#!   rec( width := 10, depth := 10, color := "blue" )
#! ];
#! JUPVIZRecordsKeychainLookup( myRecs, [ "height" ], 0 );              # = 50
#! JUPVIZRecordsKeychainLookup( myRecs, [ "width" ], 0 );               # = 50
#! JUPVIZRecordsKeychainLookup( myRecs, [ "depth" ], 0 );               # = 10
#! JUPVIZRecordsKeychainLookup( myRecs, [ "title", "text" ], "Title" ); # = "GAP"
#! JUPVIZRecordsKeychainLookup( myRecs, [ "color" ], "" );              # = "blue"
#! JUPVIZRecordsKeychainLookup( myRecs, [ "flavor" ], fail );           # = fail
#! @EndLog
DeclareGlobalFunction( "JUPVIZRecordsKeychainLookup" );

#! @Arguments record, others, chain, default, action
#! @Returns nothing
#! @Description
#!  This function is designed to make it easier to write new entries in the
#!  <Ref Var="ConvertDataSeriesForTool"/> and
#!  <Ref Var="ConvertGraphForTool"/> functions.
#!  Those functions are often processing a list of records (here called
#!  <Code>others</Code>) sometimes with one record the most important one
#!  (here called <Code>record</Code>) and looking up a <Code>chain</Code> of
#!  keys (using <Code>default</Code> just as in
#!  <Ref Func="JUPVIZRecordKeychainLookup"/>) and then taking some
#!  <Code>action</Code> based on the result.
#!  This function just allows all of that to be done with a single call.
#!  <P/>
#!  Specifically, it considers the array of records formed by
#!  <Code>Concatenation([record],others)</Code> and calls
#!  <Ref Func="JUPVIZRecordsKeychainLookup"/> on it with the given
#!  <Code>chain</Code> and <Code>default</Code>.  (If the <Code>chain</Code>
#!  is a string, it is automatically converted to a length-one list with
#!  the string inside.)  Whatever the result, the function
#!  <Code>action</Code> is called on it, even if it is the default.
#!  <P/>
#! @BeginLog
#! # Trivial examples:
#! myRec := rec( a := 5 );
#! myRecs := [ rec( b := 3 ), rec( a := 6 ) ];
#! f := function ( x ) Print( x, "\n" ); end;
#! JUPVIZFetchWithDefault( myRec, myRecs, "a", 0, f );       # prints 5
#! JUPVIZFetchWithDefault( myRec, myRecs, "b", 0, f );       # prints 3
#! JUPVIZFetchWithDefault( myRec, myRecs, "c", 0, f );       # prints 0
#! JUPVIZFetchWithDefault( myRec, myRecs, ["a","b"], 0, f ); # prints 0
#! # Useful example:
#! JUPVIZFetchWithDefault( primaryRecord, secondaryRecordsList,
#!   [ "options", "height" ], 400,
#!   function ( h ) myGraphJSON.height := h; end
#! );
#! @EndLog
#!  <P/>
#!  See also <Ref Func="JUPVIZFetchIfPresent"/>.
DeclareGlobalFunction( "JUPVIZFetchWithDefault" );

#! @Arguments record, others, chain, action
#! @Returns nothing
#! @Description
#!  This function is extremely similar to
#!  <Ref Func="JUPVIZFetchWithDefault"/> with the following exception:
#!  No default value is provided, and thus if the lookup fails for all the
#!  records (including <Code>record</Code> and everything in
#!  <Code>others</Code>) then the <Code>action</Code> is not called.
#!  <P/>
#!  Examples:
#! @BeginLog
#! myRec := rec( a := 5 );
#! myRecs := [ rec( b := 3 ), rec( a := 6 ) ];
#! f := function ( x ) Print( x, "\n" ); end;
#! JUPVIZFetchIfPresent( myRec, myRecs, "a", 0, f );       # prints 5
#! JUPVIZFetchIfPresent( myRec, myRecs, "b", 0, f );       # prints 3
#! JUPVIZFetchIfPresent( myRec, myRecs, "c", 0, f );       # does nothing
#! JUPVIZFetchIfPresent( myRec, myRecs, ["a","b"], 0, f ); # does nothing
#! @EndLog
DeclareGlobalFunction( "JUPVIZFetchIfPresent" );

#! @Section Representation wrapper

#! This code is documented for completeness's sake only.  It is not needed
#! for clients of this package.  Package maintainers may be interested in it
#! in the future.
#! <P/>
#! The <Package>JupyterKernel</Package> package defines a method
#! <Code>JupyterRender</Code> that determines how &GAP; data will be shown
#! to the user in the Jupyter notebook interface.  When there is no method
#! implemented for a specific data type, the fallback method uses the
#! built-in &GAP; method <Code>ViewString</Code>.
#! <P/>
#! This presents a problem, because we are often transmitting string data
#! (the contents of JavaScript files) from the &GAP; kernel to the notebook,
#! and <Code>ViewString</Code> is not careful about how it escapes
#! characters such as quotation marks, which can seriously mangle code.
#! Thus we must define our own type and <Code>JupyterRender</Code> method
#! for that type, to prevent the use of <Code>ViewString</Code>.
#! <P/>
#! The declarations documented below do just that.  In the event that
#! <Code>ViewString</Code> were upgraded to more useful behavior, this
#! workaround could probably be removed.  Note that it is used explicitly
#! in the <File>using-library.js</File> file in this package.

#! @Description
#!  The type we create is called <Code>FileContents</Code>, because that is
#!  our purpose for it (to preserve, unaltered, the contents of a text
#!  file).
DeclareCategory( "JUPVIZIsFileContents", IsObject );

#! @Description
#!  The representation for the <Code>FileContents</Code> type
DeclareRepresentation( "JUPVIZIsFileContentsRep",
    IsComponentObjectRep and JUPVIZIsFileContents, [ "content" ] );

#! @Description
#!  A constructor for <Code>FileContents</Code> objects
DeclareOperation( "JUPVIZFileContents", [ IsString ] );

#! Elsewhere, the <Package>JupyterViz</Package> package also installs a
#! <Code>JupyterRender</Code> method for <Code>FileContents</Code> objects
#! that just returns their text content untouched.

#E  main.gd  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
