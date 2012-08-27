package freyja.async 
{
	/**
     * 用來監看字串數值的變化，在特定數值的時候引發 enter 與 exit 事件。
     */
    public class StringWatcher 
    {
        private var m_enterActions: Object = new Object;
        private var m_exitActions:  Object = new Object;
        
        private var m_current: String = "";
        
        
        public function get current() : String
        {
            return m_current;
        }
        
        public function AddActions( value: String, enterAction: Function, exitAction: Function = null ) : void
        {
            if ( null != enterAction )
            {
                if ( undefined != m_enterActions[ value ] ) { throw Error( "Value is duplicate : " + value ); }
                
                m_enterActions[ value ] = enterAction;
            }

            if ( null != exitAction )
            {
                if ( undefined != m_exitActions[ value ] ) { throw Error( "Value is duplicate : " + value ); }
                
                m_exitActions[ value ] = exitAction;
            }
        }
        
        public function Update( newValue: String ) : void
        {
            if ( m_current == newValue ) { return; }
        
            var exitAction: Function = m_exitActions[ m_current ];
            if ( null != exitAction )
            {
                exitAction();
            }
            
            m_current = newValue;
            
            var enterAction: Function = m_enterActions[ m_current ];
            if ( null != enterAction )
            {
                enterAction();
            }
        }
    }

}