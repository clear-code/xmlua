#!/usr/bin/env luajit

local xmlua = require("xmlua")

local listener = {}

function listener:start_document()
  print("Start document")
end

function listener:print_element_content(content, indent)
  if content.type == "PCDATA" then
    print(indent .. "type: " .. content.type)
    print(indent .. "occur: " .. content.occur)
  elseif content.type == "ELEMENT" then
    print(indent .. "type: " .. content.type)
    print(indent .. "occur: " .. content.occur)
    print(indent .. "prefix: " .. (content.prefix or ""))
    print(indent .. "name: " .. content.name)
  else
    print(indent .. "type: " .. content.type)
    print(indent .. "occur: " .. content.occur)
    for i, child in pairs(content.children) do
      print(indent .. "child[" .. i .. "]:")
      self:print_element_content(child, indent .. "  ")
    end
  end
end

function listener:element_declaration(name, element_type, content)
  print("Element name: " .. name)
  print("Element type: " .. element_type)
  if element_type == "EMPTY" then
    return
  end
  print("Content:")
  self:print_element_content(content, "  ")
end

function listener:attribute_declaration(name,
                                        attribute_name,
                                        attribute_type,
                                        default_value_type,
                                        default_value,
                                        enumerated_values)
  print("Element name: " .. name)
  print("Attribute name: " .. attribute_name)
  print("Attribute type: " .. attribute_type)
  if default_value then
    print("Default value type: " .. default_value_type)
    print("Default value: " .. default_value)
  end
  for _, v in pairs(enumerated_values) do
    print("Enumrated value: " .. v)
  end
end

function listener:notation_declaration(name, public_id, system_id)
  print("Notation name: " .. name)
  if public_id ~= nil then
    print("Notation public id: " .. public_id)
  end
  if system_id ~= nil then
    print("Notation system id: " .. system_id)
  end
end

function listener:unparsed_entity_declaration(name,
                                              public_id,
                                              system_id,
                                              notation_name)
  print("Unparserd entity name: " .. name)
  if public_id ~= nil then
    print("Unparserd entity public id: " .. public_id)
  end
  if system_id ~= nil then
    print("Unparserd entity system id: " .. system_id)
  end
  print("Unparserd entity notation_name: " .. notation_name)
end

function listener:entity_declaration(name,
                                     entity_type,
                                     public_id,
                                     system_id,
                                     content)
  print("Entity name: " .. name)
  print("Entity type: " .. entity_type)
  if public_id ~= nil then
    print("Entity public id: " .. public_id)
  end
  if system_id ~= nil then
    print("Entity system id: " .. system_id)
  end
  print("Entity content: " .. content)
end

function listener:internal_subset(name, external_id, system_id)
  print("Internal subset name: " .. name)
  if external_id ~= nil then
    print("Internal subset external id: " .. external_id)
  end
  if system_id ~= nil then
    print("Internal subset system id: " .. system_id)
  end
end

function listener:external_subset(name, external_id, system_id)
  print("External subset name: " .. name)
  if external_id ~= nil then
    print("External subset external id: " .. external_id)
  end
  if system_id ~= nil then
    print("External subset system id: " .. system_id)
  end
end

function listener:cdata_block(cdata_block)
  print("CDATA block: " .. cdata_block)
end

function listener:comment(comment)
  print("Comment: " .. comment)
end

function listener:processing_instruction(target, data)
  print("Processing instruction target: " .. target)
  print("Processing instruction data: " .. data)
end

function listener:ignorable_whitespace(ignorable_whitespaces)
  print("Ignorable whitespaces: " .. "\"" .. ignorable_whitespaces .. "\"")
  print("Ignorable whitespaces length: " .. #ignorable_whitespaces)
end

function listener:text(text)
  print("Text: <" .. text .. ">")
end

function listener:reference(entity_name)
  print("Reference entity name: " .. entity_name)
end

function listener:start_element(local_name,
                                prefix,
                                uri,
                                namespaces,
                                attributes)
  print("Start element: " .. local_name)
  if prefix then
    print("  prefix: " .. prefix)
  end
  if uri then
    print("  URI: " .. uri)
  end
  for namespace_prefix, namespace_uri in pairs(namespaces) do
    if namespace_prefix  == "" then
      print("  Default namespace: " .. namespace_uri)
    else
      print("  Namespace: " .. namespace_prefix .. ": " .. namespace_uri)
    end
  end
  if attributes then
    if #attributes > 0 then
      print("  Attributes:")
      for i, attribute in pairs(attributes) do
        local name
        if attribute.prefix then
          name = attribute.prefix .. ":" .. attribute.local_name
        else
          name = attribute.local_name
        end
        if attribute.uri then
          name = name .. "{" .. attribute.uri .. "}"
        end
        print("    " .. name .. ": " .. attribute.value)
      end
    end
  end
end

function listener:end_element(local_name, prefix, uri)
  print("End element: " .. local_name)
  if prefix then
    print("  prefix: " .. prefix)
  end
  if uri then
    print("  URI: " .. uri)
  end
end

function listener:warning(message)
  print("Warning message:", message)
  print("Pedantic:", parser.is_pedantic)
end

function listener:error(xml_error)
  print("Error domain:", xml_error["domain"])
  print("Error code:", xml_error["code"])
  print("Error message:", xml_error["message"])
  print("Error level:", xml_error["level"])
  print("Error line:", xml_error["line"])
end

function listener:end_document()
  print("End document")
end

local parser = xmlua.XMLStreamSAXParser.new(listener)

while true do
  local line = io.stdin:read()
  if not line then
    parser:finish()
    break
  end
  parser:parse(line)
end
