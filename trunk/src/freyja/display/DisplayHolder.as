package freyja.display 
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    
	/**
     * 用於確保一系列顯示物件中，僅有一個會位於顯示列表中。
     */
    public class DisplayHolder
    {
        private var m_parent: DisplayObjectContainer = null;
        private var m_child:  DisplayObject = null;
    
        public function DisplayHolder( parent: DisplayObjectContainer = null ) 
        {
            m_parent = parent;
        }
        
        public function set parent( newParent: DisplayObjectContainer ) : void
        {
            if ( null == newParent ) { throw ArgumentError( "The new parent can't be null" ); }
        
            if ( m_parent === newParent ) { return; }
            
            m_parent = newParent;
            
            if ( null != m_child )
            {
                m_parent.addChild( m_child );
            }
        }
        
        public function set child( newChild: DisplayObject ) : void
        {
            if ( null == newChild ) { throw ArgumentError( "The new child can't be null" ); }
            
            if ( null == m_parent ) { throw Error( "No parent avaiable" ); }
            
            if ( m_child === newChild ) { return; }
            
            if ( null != m_child )
            {
                m_parent.removeChild( m_child );
            }
            
            m_parent.addChild( newChild );
            m_child = newChild;
        }
        
        public function Clear() : void
        {
            if ( null != m_child )
            {
                m_parent.removeChild( m_child );
                m_child = null;
            }
        }
    }

}