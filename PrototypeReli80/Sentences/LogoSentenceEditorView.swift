//
//  SentenceEditorView.swift
//  PrototypeReli80
//
//  Created by Vincent Zhou on 4/19/22.
//

import SwiftUI
import CoreData

struct LogoSentenceEditorView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: LogoSentenceEditorViewModel
    
    let preview: Bool
    init(preview: Bool = false) {
        _vm = StateObject(wrappedValue: LogoSentenceEditorViewModel(preview: preview))
        self.preview = preview
    }
    init(sentence: SyncObject<LogographicSentence, LogographicSentenceDB>, preview: Bool = false) {
        _vm = StateObject(wrappedValue: LogoSentenceEditorViewModel(sentence: sentence, preview: preview))
        self.preview = preview
    }
    
    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
//            GridItem(.flexible()),
//            GridItem(.flexible()),
//            GridItem(.flexible()),
//            GridItem(.flexible())
        ]
        
        VStack(alignment: .leading) {
            Text("Language: \(vm.sentence.decoded.language.name)")
            LazyVGrid(columns: columns, spacing: 5) {
                ForEachWithIndex(vm.sentence.decoded.sentence) {
                    idx, logogram in
                    Button {
                        vm.editSheet = true
                    } label: {
                        ScaleableDrawingView(drawing: logogram.drawing, border: true).scaledToFit()
                    }
                    .sheet(isPresented: $vm.editSheet) {
                        LogoSheetEditView(viewContext: vm.viewContext, sentence: $vm.sentence, choosenIdx: idx, binding: $vm.editSheet)
                    }
                }
                
                Button {
                    vm.newSheet = true
                } label : {
                    Rectangle().foregroundColor(.clear).scaledToFit().border(.blue, width: 2.0).overlay(alignment:.center) {
                        Image(systemName: "plus").font(.largeTitle).foregroundColor(.blue)
                    }
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $vm.newSheet) {
                    LogoSheetNewView(viewContext: vm.viewContext, sentence: $vm.sentence, binding: $vm.newSheet)
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    vm.save()
                    dismiss()
                } label: {
                    Text("Save")
                }.disabled(vm.sentence.synced)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

struct LogoSentenceEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LogoSentenceEditorView(preview: true).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
class LogoSheetViewModel: ObservableObject {
    @Published var viewContext: NSManagedObjectContext
    @Binding var sentence: SyncObject<LogographicSentence, LogographicSentenceDB>
    @Binding var binding: Bool
    
    init (viewContext: NSManagedObjectContext, sentence: Binding<SyncObject<LogographicSentence, LogographicSentenceDB>>, binding: Binding<Bool>) {
        self.viewContext = viewContext
        self._sentence = sentence
        self._binding = binding
    }
}
struct LogoSheetEditView: View {
    @StateObject var vm: LogoSheetViewModel
    
    init (viewContext: NSManagedObjectContext, sentence: Binding<SyncObject<LogographicSentence, LogographicSentenceDB>>, choosenIdx: Int, binding: Binding<Bool>) {
        _vm = StateObject(wrappedValue: LogoSheetViewModel(viewContext: viewContext, sentence: sentence, binding: binding))
        self.choosenIdx = choosenIdx
    }
    
    var choosenIdx: Int
    
    var body: some View {
        Form {
            Section("Logograms") {
                List {
                    ForEachWithIndex(vm.sentence.decoded.language.logograms) {
                        idx, logogram in
                        Button {
                            vm.sentence.decoded.sentence[idx] = logogram.copy()
//                            vm.sentence.saveManagedObject()
                            vm.binding = false
                        } label: {
                            Text("\(logogram.meaning)")
                        }
                    }
                }
            }
            Section() {
                Button {
                    vm.sentence.decoded.sentence.remove(at: choosenIdx)
//                    vm.sentence.saveManagedObject()
                    vm.binding = false
                } label: {
                    Text("Delete").foregroundColor(.red)
                }
            }
        }
    }
}
struct LogoSheetNewView: View {
    @StateObject var vm: LogoSheetViewModel

    init (viewContext: NSManagedObjectContext, sentence: Binding<SyncObject<LogographicSentence, LogographicSentenceDB>>, binding: Binding<Bool>) {
        _vm = StateObject(wrappedValue: LogoSheetViewModel(viewContext: viewContext, sentence: sentence, binding: binding))
    }
        
    var body: some View {
        Form {
            Section("Logograms") {
                List {
                    ForEachWithIndex(vm.sentence.decoded.language.logograms) {
                        idx, logogram in
                        Button {
                            vm.sentence.decoded.sentence.append(logogram.copy())
//                            vm.sentence.saveManagedObject()
                            vm.binding = false
                        } label: {
                            Text("\(logogram.meaning)")
                        }
                    }
                }
            }
        }
    }
}
