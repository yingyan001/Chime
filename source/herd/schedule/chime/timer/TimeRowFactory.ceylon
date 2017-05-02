import ceylon.json {
	
	JSON=Object
}
import ceylon.collection {

	HashMap
}
import herd.schedule.chime {

	Chime
}


"Factory to create timers."
since( "0.1.0" ) by( "Lis" )
shared interface TimeRowFactory
{
	shared formal TimeRow|<Integer->String> createTimer( "Timer description." JSON description );
}


"Base timer factory.  
 Uses type -> creator function map to create timers.  
 Before create timers add creators using [[addCreator]]"
by( "Lis" )
shared class FactoryJSONBase() satisfies TimeRowFactory
{
	
	"type -> creator function map"
	HashMap<String, <TimeRow|<Integer->String>>(JSON)> creators = HashMap<String, <TimeRow|<Integer->String>>(JSON)>();
	
	
	"Adds creator to the factory."
	shared void addCreator( "Timer type." String type, "Creator function." <TimeRow|<Integer->String>>(JSON) creator ) {
		creators.put( type, creator );
	}
	
	"Searches creators from added via [[addCreator]] and use them to create timers.  
	 description to contain field \"type\" which is used to find creator function."
	shared actual TimeRow|<Integer->String> createTimer( "timer description" JSON description ) {
		if ( is String type = description[Chime.key.type] ) {
			if ( exists creator = creators[type] ) {
				return creator( description );
			}
			else {
				return Chime.errors.codeUnsupportedTimerType->Chime.errors.unsupportedTimerType;
			}
		}
		else {
			return Chime.errors.codeTimerTypeHasToBeSpecified->Chime.errors.timerTypeHasToBeSpecified;
		}
	}
	
}