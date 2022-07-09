

// -----( IS Java Code Template v1.2

import com.wm.data.*;
import com.wm.util.Values;
import com.wm.app.b2b.server.Service;
import com.wm.app.b2b.server.ServiceException;
// --- <<IS-START-IMPORTS>> ---
import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
// --- <<IS-END-IMPORTS>> ---

public final class services

{
	// ---( internal utility methods )---

	final static services _instance = new services();

	static services _newInstance() { return new services(); }

	static services _cast(Object o) { return (services)o; }

	// ---( server methods )---




	public static final void getAttributesList (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(getAttributesList)>> ---
		// @sigtype java 3.5
		// [o] field:1:required attributes
		// pipeline
		IDataCursor pipelineCursor = pipeline.getCursor();
		String[] attributes = new String[10];
		attributes[0] = "sAMAccountName";
		attributes[1] = "givenName";
		attributes[2] = "mail";
		attributes[3] = "l";
		attributes[4] = "postalCode";
		attributes[5] = "c";
		attributes[6] = "whenCreated";
		attributes[7] = "sn";
		attributes[8] = "title";
		attributes[9] = "name";
		
		
		IDataUtil.put( pipelineCursor, "attributes", attributes );
		pipelineCursor.destroy();
		
			
		// --- <<IS-END>> ---

                
	}



	public static final void getPassword (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(getPassword)>> ---
		// @sigtype java 3.5
		// [i] field:0:required password
		// [o] field:0:required unicodePwd
		// pipeline
		IDataCursor pipelineCursor = pipeline.getCursor();
			String	password = IDataUtil.getString( pipelineCursor, "password" );
		pipelineCursor.destroy();
		
		String quotedPassword = "\"" + password + "\"";
		byte[] bt;
		try {
			bt = quotedPassword.getBytes("UTF-16LE");
		} catch (UnsupportedEncodingException e) {
			throw new ServiceException(e);
		}
		
		
		// pipeline
		IDataCursor pipelineCursor_1 = pipeline.getCursor();
		IDataUtil.put( pipelineCursor_1, "unicodePwd", bt );
		pipelineCursor_1.destroy();
		
			
		// --- <<IS-END>> ---

                
	}



	public static final void getUserAccountControl (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(getUserAccountControl)>> ---
		// @sigtype java 3.5
		// [o] object:0:required userAccountControl
		// pipeline
		
		byte[] userAccountControl = "512".getBytes(StandardCharsets.US_ASCII);
		//Object userAccountControl = "0x200";
		
		// pipeline
		IDataCursor pipelineCursor = pipeline.getCursor();
		//Object userAccountControl = new Object();
		IDataUtil.put( pipelineCursor, "userAccountControl", userAccountControl );
		pipelineCursor.destroy();
			
		// --- <<IS-END>> ---

                
	}



	public static final void getUserName (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(getUserName)>> ---
		// @sigtype java 3.5
		// [i] field:0:required lastName
		// [i] field:0:required firstName
		// [o] field:0:required userName
		// pipeline
		IDataCursor pipelineCursor = pipeline.getCursor();
			String	lastName = IDataUtil.getString( pipelineCursor, "lastName" );
			String	firstName = IDataUtil.getString( pipelineCursor, "firstName" );
		pipelineCursor.destroy();
				
		String userName = Normalizer.normalize(firstName + "." + lastName, Normalizer.Form.NFD)
		.replaceAll("[^\\p{ASCII}]", "").toLowerCase();
		
		// pipeline
		IDataCursor pipelineCursor_1 = pipeline.getCursor();
		IDataUtil.put( pipelineCursor_1, "userName", userName );
		pipelineCursor_1.destroy();
		
			
		// --- <<IS-END>> ---

                
	}
}

