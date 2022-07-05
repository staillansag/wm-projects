package ContractManagement;

// -----( IS Java Code Template v1.2

import com.wm.data.*;
import com.wm.util.Values;
import com.wm.app.b2b.server.Service;
import com.wm.app.b2b.server.ServiceException;
// --- <<IS-START-IMPORTS>> ---
// --- <<IS-END-IMPORTS>> ---

public final class service

{
	// ---( internal utility methods )---

	final static service _instance = new service();

	static service _newInstance() { return new service(); }

	static service _cast(Object o) { return (service)o; }

	// ---( server methods )---




	public static final void extractParty (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(extractParty)>> ---
		// @sigtype java 3.5
		// [i] record:0:required input
		// [i] - recref:0:required party ContractManagement.doc:Party
		// [o] recref:0:required party ContractManagement.doc:Party
		// pipeline
		IDataCursor pipelineCursor = pipeline.getCursor();
		 
			// input
			IData	input = IDataUtil.getIData( pipelineCursor, "input" );
			IData	party = null;
			if ( input != null)
			{
				IDataCursor inputCursor = input.getCursor();		
				// i.party
				party = IDataUtil.getIData( inputCursor, "party" );
				inputCursor.destroy();
			}
		pipelineCursor.destroy();
		
		// pipeline
		IDataCursor pipelineCursor_1 = pipeline.getCursor();
		
		IDataUtil.put( pipelineCursor_1, "party", party );
		pipelineCursor_1.destroy();
		
			
		// --- <<IS-END>> ---

                
	}
}

