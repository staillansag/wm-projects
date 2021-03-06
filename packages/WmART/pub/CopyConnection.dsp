%comment%------ Display configured connection node ------%endcomment%
%comment%----- LG TRAX 1-MHXZY -----%endcomment%
%comment%----- Move occurrances of swaprows() to make alternate -----%endcomment%
%comment%----- display lines in form have alternating colors -----%endcomment%
<HTML>
    <head>
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
    <meta http-equiv="Expires" CONTENT="-1">
    <title>Connection Details</title>
    <link rel="stylesheet" TYPE="text/css" HREF="../WmRoot/webMethods.css"></link>
	<Link REL="stylesheet" TYPE="text/css" HREF="../WmART/webMethods.css"></LINK>
    <SCRIPT SRC="../WmRoot/webMethods.js"></SCRIPT>
	<script src="lookUp.js"></script>
    <script src="artconnjs.js"></script>
	<script SRC="../%value adapterPackageName%/adapterConnPropValidator.js"></script>		
	<SCRIPT SRC="csrfGuard.js"></SCRIPT>
    </head>


<body>
<form name="form" action="ListResources.dsp" method="POST">
<input type="hidden" name="action" value="saveConnection">
<input type="hidden" name="passwordChange" value="false">
<input type="hidden" name="searchConnectionName" value="%value searchConnectionName%">

    %invoke wm.art.admin:retrieveAdapterTypeData%
    %onerror%
    %endinvoke%
  
		%ifvar test equals(true)%
			<INPUT NAME="test" TYPE="hidden" VALUE="true">
		%else%
			%ifvar test equals(completed)%
				<INPUT NAME="test" TYPE="hidden" VALUE="completed">
			%else%
				<INPUT NAME="test" TYPE="hidden" VALUE="false">
			%endif%
		%endif%
    <table width=100%>
    <tr>
    <td class="breadcrumb" colspan=4>Adapters &gt; %value displayName% &gt; Copy Connection</td>
    </tr>
  
			%ifvar test equals(true)%
			  %invoke wm.art.admin.connection:testResource% 
			  <SCRIPT>testCompleted();</SCRIPT>
			  %ifvar message%
				<TR><TD class="message" colspan="8">%value message encode(html)%</TD></TR>
			  %else%
			  %endif%
			  %onerror%
				 %ifvar localizedMessage%
                        <tr><td class="message" colspan=8>Error encountered <pre>%value localizedMessage%</pre></td></tr>
                    %else%
                        %ifvar error%
                             <tr><td class="message" colspan=8>Error encountered <pre>%value errorMessage%</pre></td></tr>
                        %endif%
                    %endif%				
			  %endinvoke%
			%endif%
    <tr>
    <td colspan=2>
        <ul>
        <li><A id="Return_to_%value displayName%_Connections" HREF="ListResources.dsp?adapterTypeName=%value -urlencode adapterTypeName%&searchConnectionName=%value -urlencode searchConnectionName%&dspName=.LISTRESOURCES">Return to %value displayName% Connections</A><script>updateURL("Return_to_%value displayName%_Connections", "Return to %value displayName% Connections");</script>
        </ul>
    </td>
    </tr>
	
	<tr>
	<td>
	<table class="tableView" width="100%">
	<tbody>
    %invoke wm.art.admin.connection:getResourceConfiguration%
    <tr>
        <td class="heading" colspan=2>Configure Connection Type &gt; %value mcfDisplayName% Copy</td>
    </tr>


    <script>setNavigation('ListResources.dsp', '%value encode(javascript) TemplateURL%', 'foo');</script>
    <script>resetRows();</script>
    <tr>
    
        %include GetISPackages.dsp%
            <script>swapRows();writeTD('row');</script>
             Folder Name</td>
            <script>writeTD('rowdata-l');</script>
            <input size=30 name="resourceFolderName" value="%value -urlencode resourceFolderName%"></input></td>          
    </tr>
    <tr>
            <script>swapRows();writeTD('row');</script>
            Connection Name</td>
            <script>writeTD('rowdata-l');</script>
            <input size=30 name="resourceName" value="%value -urlencode resourceName%"></input></td>
    </tr>       
    %comment%-- LG TRAX 1-MHXP3 --%endcomment%
    %comment%-- Changed to point to NEW COPY ONLY .dsp --%endcomment%
    %comment%-- Changed for Elbe Release    --%endcomment%
	
	%ifvar test equals(true)%
		%include EditConnectionProperties.dsp%  
	%else%
		%include EditConnectionCopyProperties.dsp%
	%endif%
       
    %comment%----------------------ConnectionManagerProperties--------------%endcomment%    
    %include EditConnectionManagerProperties.dsp%
    %comment%----------------------End ConnectionManagerProperties--------------%endcomment%  
    
    %onerror%
      %ifvar localizedMessage%
        %comment%-- Localized error message supplied --%endcomment%
        <tr><td class="message">Error encountered <%value error%> %value localizedMessage%</td></tr>
      %else%
        %ifvar error%
          <tr><td class="message">Error encountered <%value error%> %value errorMessage%</td></tr>
        %endif%
      %endif%
    %endinvoke%
	</tbody>
	</table>
	</td>
	</tr>
    </table>
       
    <table width=100%>
    <tr>
    <td class="action" colspan="2">
        <input type="submit" name="SUBMIT" value="Save Connection Copy" width=100 onclick="return validateForm(this.form)"></input>
			<input type="submit" name="TEST" value="Test Connection" onClick="return testConnection('CopyConnection.dsp');" />
            <input type="hidden" name="adapterTypeName" value="%value adapterTypeName%">
        <input type="hidden" name="connectionFactoryType" value="%value connectionFactoryType%"> 
         
    </TD>    
    </tr>
    </table>
    </form>    
</body>
</HTML>