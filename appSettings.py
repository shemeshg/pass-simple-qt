from string import Template

a = [
    ["QString",'passwordStorePath'],
    ["QString",'tmpFolderPath'],
    ["QString",'gitExecPath'],
    ["QString",'vscodeExecPath'],
    ["QString",'autoTypeCmd'],
    ["QString",'ctxSigner'],
    ["QString",'fontSize'],
    ["QString",'commitMsg'],
    ["QString",'appVer',"CONSTANT"],
    ["QString",'binaryExts'],
    ["bool",'useClipboard',"","false"],
    ["bool",'doSign',"","false"],
    ["bool",'preferYamlView',"","true"],    
    ["bool",'isFindMemCash',"","false"],
    ["bool",'isFindSlctFrst',"","false"],
    ["bool",'isShowPreview',"","true"],
    ["int",'openWith',"","0"],
    ]   

def initCapital(s):
    return s[0].upper() + s[1:]

def getQ_Property(row):
    field_type = row[0]
    p = row[1] 
    p_capitalize = initCapital(p)
    if len(row) > 2 and row[2]=="CONSTANT":
        t = Template("""
        Q_PROPERTY( ${field_type} $p READ $p CONSTANT)""")
        return t.substitute(p=p,
            field_type=field_type, p_capitalize=p_capitalize)

    else:
        t = Template("""
        Q_PROPERTY( ${field_type} $p READ $p WRITE set${p_capitalize} NOTIFY ${p}Changed)""")
        return t.substitute(p=p,
            field_type=field_type, p_capitalize=p_capitalize)

def getQ_Properties():
    s=""
    for row in a:
        s = s + getQ_Property(row)
    return s

def getQ_header_private(row):
    field_type = row[0]
    p = row[1] 
    if len(row) > 2 and row[2]=="CONSTANT":
        return ""
    else:
        t = Template("""
        ${field_type} m_$p;""")
        return t.substitute(p=p,
            field_type=field_type)

def getQ_header_privates():
    s=""
    for row in a:
        s = s + getQ_header_private(row)
    return s      

def getQ_header_signal(row):
    field_type = row[0]
    p = row[1] 
    if len(row) > 2 and row[2]=="CONSTANT":
        return ""
    else:
        t = Template("""
        void ${p}Changed();""")
        return t.substitute(p=p)

def getQ_header_signals():
    s=""
    for row in a:
        s = s + getQ_header_signal(row)
    return s    

def getQ_header_public(row):
    field_type = row[0]
    p = row[1] 
    p_capitalize = initCapital(p)
    if len(row) > 2 and row[2]=="CONSTANT":
        return ""
    else:
        if field_type == "QString":
            t = Template("""
            const QString ${p}() const;
            void set${p_capitalize}(const QString &${p});""")
            return t.substitute(p=p,p_capitalize=p_capitalize)
        elif field_type == "bool" or field_type == "int":
            t = Template("""
            ${field_type} ${p}() const { return m_${p}; };
            void set${p_capitalize}(const ${field_type} ${p});""")
            return t.substitute(p=p,p_capitalize=p_capitalize,field_type=field_type)            
        else:
            return ""

def getQ_header_publics():
    s=""
    for row in a:
        s = s + getQ_header_public(row)
    return s   

def getQ_src_contr(row):
    field_type = row[0]
    p = row[1] 
    p_capitalize = initCapital(p)
    if len(row) > 2 and row[2]=="CONSTANT":
        return ""
    else:
        if field_type == "QString":
            t = Template("""
            m_${p} = settings.value("${p}", "").toString();""")
            return t.substitute(p=p)
        elif field_type == "bool":
            p_default = row[3]
            t = Template("""
            m_${p} = settings.value("${p}", ${p_default}).toBool();""")
            return t.substitute(p=p,p_default=p_default)    
        elif field_type == "int":
            p_default = row[3]
            t = Template("""
            m_${p} = settings.value("${p}", ${p_default}).toInt();""")
            return t.substitute(p=p,p_default=p_default)                    
        else:
            return ""

def getQ_src_contrs():
    s=""
    for row in a:
        s = s + getQ_src_contr(row)
    return s        
"""
print(getQ_Properties())
"""
